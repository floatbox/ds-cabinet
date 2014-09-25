# Describes registration process.
# Registration has a state. States and transitions are described in `workflow` block below.
# Brief information about the states:
#   * new                     Registration is just created and not even saved
#   * awaiting_confirmation   It was saved to the database. Now it should be confirmed by user.
#   * awaiting_verification   It was confirmed. User should enter SMS code to verify it.
#   * awaiting_payment        The phone is verified. User should make payment.
#   * awaiting_password       It was verified. User should enter password.
#   * done                    Everything is done, data was sent to UAS, SNS and Siebel.
#
require 'phone'
require 'password_sms_notifier'

class Registration < ActiveRecord::Base

  belongs_to :user
  has_one :password_notification_attempts, as: :attemptable, class_name: Attempt::RegistrationPasswordNotification

  include Workflow

  SPARK_ATTRIBUTES = { inn: :inn, company_name: :name, region_code: :region_code }
  UNKNOWN_NAME = 'Не определено'

  attr_accessor :password_confirmation

  serialize :uas_user, Uas::User

  validates_presence_of :phone, :ogrn
  validates_format_of :phone, with: Phone::RegExp
  validates_format_of :ogrn, with: /\A([0-9]{13})([0-9]{2})?\Z/i
  validate :phone_uniqueness, if: :new_record?
  validate :company_exists, if: :new_record?
  validates_presence_of :password, :password_confirmation, if: :awaiting_confirmation?
  validates_length_of :password, minimum: PasswordGenerator.length, if: :awaiting_confirmation?
  validate :password_equals_to_confirmation, if: :awaiting_confirmation?

  workflow do
    state :new do
      event :start,    :transitions_to => :awaiting_confirmation
      event :defer,    :transitions_to => :deferred
    end
    state :awaiting_confirmation do
      event :confirm,  :transitions_to => :awaiting_payment
    end
    state :awaiting_payment do
      event :confirm_payment, :transitions_to => :done
    end
    state :deferred
    state :done
  end

  # Remove symbols from the phone number
  def phone=(value)
    write_attribute(:phone, Phone.new(value).value)
  end

  def ogrn=(value)
    if value != ogrn || inn.nil? || company_name.nil?
      @company = nil
      write_attribute(:ogrn, value)
      SPARK_ATTRIBUTES.each do |attribute, spark_attribute|
        write_attribute(attribute, company.try(spark_attribute))
      end
    end
  end

  SPARK_ATTRIBUTES.each do |attribute, spark_attribute|
    define_method attribute do
      value = read_attribute(attribute)
      value ? value : write_attribute(attribute, company.try(spark_attribute))
    end
  end

  def company
    @company ||= Ds::Spark::Company.find_by_ogrn_or_ogrnip(ogrn)
    #<Ds::Spark::Company:0x007f2a0c362120 @spark_id="6324149", @inn="7723643863", 
    #  @ogrn="1087746061523", @ogrnip=nil, 
    #  @name="ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"РОГА И КОПЫТА\"", @region_code="45"
    #>
  rescue => e
    logger.error "Can not find company in Spark. #{e.message}"
    nil
  end

  def user
    @user = { phone: phone }
  end

  def name
    company_name
  end

  def as_json(options = {})
    self.class.include_root_in_json = true
    super((options || {}).merge({
      methods: [:inn, :name, :workflow_state, :first_name, :last_name]
    }))
  end

  # Sends notification about this registration to admin
  def notify_admin
    return if admin_notified?
    update_column(:admin_notified, true) if persisted?
    RegistrationMailer.admin_notification_email(self).deliver
  end

  def send_password_sms_notification
    # sms notification as well as admin email notification should be external tasks
    unless PasswordSmsNotifier.new(phone, password).send
      RegistrationMailer.admin_password_sms_notifier_failed_email(self).deliver
    end
  end

  # @return [Boolean] whether the company with specified OGRN is alredy exists in Siebel
  def siebel_company_exists?
    find_siebel_company(ogrn) ? true : false
  end

  def self.find_by_phone_ogrn phone, ogrn
    self.where(phone: Phone.new(phone).value, ogrn: ogrn).last
  end

  # Callback on transition from awaiting_password to done state.
  def send_to_ds!
    uas_user_obj = uas_user || create_uas_user
    integration_id = uas_user_obj.user_id # "UAS100127"
    
    if contact_id.nil?
      contact    = Contact.find_by_integration_id(integration_id)
      self.update_column :contact_id, contact.id # "1-189X9O"
    end
    
    if person_id.nil?
      person = create_sns_user(contact_id)
      self.update_column :person_id, person.id # == contact_id
    else
      person = find_sns_user(person_id)
    end

    account = find_siebel_company(ogrn) || create_siebel_company
    company = find_sns_company(person, account) || create_sns_company(person, account)
    
    user_id = User.find_or_create_by(siebel_id: contact_id, integration_id: integration_id).id
    self.update_column :user_id, user_id

    if uas_user_obj.is_disabled
      uas_user_obj.is_disabled = false
      uas_user_obj.save
    end
    self.update_column :uas_user, uas_user_obj # to serialize
  rescue => e
    ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: 'Can not send data to DS' })
    logger.error "Can not send data to DS. #{e.message}"
    e.backtrace.each { |line| logger.error line }
    halt
  end

  def first_name
    company_name.split[1..2].join(' ')
  end

  def last_name
    company_name.split.first
  end

  private

    def phone_uniqueness
      errors.add(:phone, :already_exist) if phone.present? && Uas::User.exist?(phone)
    end

    def company_exists
      errors.add(:company, :does_not_exist) unless company
    end

    def password_equals_to_confirmation
      if password.present? && password_confirmation.present?
        errors.add(:password, :wrong_confirmation) unless password == password_confirmation
      end
    end

    # @return [Uas::User] new UAS user
    # @note It automatically creates Siebel user
    def create_uas_user
      Uas::User.new.tap do |user|
        user.is_disabled = true
        user.login       = phone
        user.phone       = phone
        user.password    = password
        fio_from_company_name.tap do |fio|
          user.first_name      = fio[:first_name]
          user.last_name       = fio[:last_name]
          user.patronymic_name = fio[:patronymic_name]
        end
      end.create
    end

    # @param contact [String] contact_id - Id of user representation in Siebel
    # @return [Ds::Sns::Person] existing SNS user
    def find_sns_user(contact_id)
      Ds::Sns::Person.find(contact_id)
    end

    # @param contact [Contact] Siebel representation of the user
    # @return [Person] new SNS user
    def create_sns_user(contact_id)
      Ds::Sns.su do
        person = Person.new(id: contact_id, name: UNKNOWN_NAME)
        person.save
        person
      end
    end

    # @param ogrn [String] OGRN of the company
    # @return [Account] Siebel company with specified OGRN
    # @return [nil] if nothing found
    def find_siebel_company(ogrn)
      _company = Account.where(x_sbt_ogrn: ogrn).first
      logger.info "find_siebel_company('#{ogrn}') returns #{_company.inspect}"
      _company
    end

    # @return [Account] new Siebel company
    def create_siebel_company
      account = Account.new
      account.full_name = company_name
      account.inn = inn
      account.ogrn = ogrn
      account.save!
      logger.info "create_siebel_company account after save: #{account.inspect}"
      account = Account.find_by_integration_id(account.siebel_integration_id) # Reload to get correct id
      logger.info "create_siebel_company account after find_by_integration_id('#{account.siebel_integration_id}'): #{account.inspect}"
      account
    end

    # @param person [Person] SNS user that should be the admin of the company
    # @param account [Account] Siebel representation of the company
    # @return [Company] new SNS company
    # @note Person automatically becomes the admin of the account
    def find_sns_company(person, account)
      company = Ds::Sns.as person.id, 'siebel' do
        begin
          Company.find(account.id)
        rescue
          nil
        end
      end
      Ds::Sns.su do
        person.grant_role('CompanyAdministrator', company)
      end if company
      company
    end

    # @param person [Person] SNS user that should be the admin of the company
    # @param account [Account] Siebel representation of the company
    # @return [Company] new SNS company
    # @note Person automatically becomes the admin of the account
    def create_sns_company(person, account)
      Ds::Sns.as person.id, 'siebel' do
        Company.new(id: account.id, name: account.full_name).save
      end
    end

    # Retrives user info from Spark for individual entrepreneurs
    # @return [Hash] first, last and patronymic names
    def fio_from_company_name
      if ogrn.to_s.length == 15
        values = company_name.to_s.split(' ').select(&:present?).map(&:capitalize)
        { first_name:      values[1], 
          last_name:       values[0], 
          patronymic_name: values[2] }
      else
        { first_name:      UNKNOWN_NAME, 
          last_name:       UNKNOWN_NAME, 
          patronymic_name: UNKNOWN_NAME  }
      end
    end
end
