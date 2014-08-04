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

class Registration < ActiveRecord::Base
  include Workflow

  SPARK_ATTRIBUTES = { inn: :inn, company_name: :name, region_code: :region_code }

  attr_accessor :password, :password_confirmation

  validates_presence_of :phone, :ogrn
  validates_format_of :phone, with: Phone::RegExp
  validates_format_of :ogrn, with: /\A([0-9]{13})([0-9]{2})?\Z/i
  validate :phone_uniqueness, if: :new_record?
  validate :company_exists, if: :new_record?
  validates_presence_of :password, :password_confirmation, if: :awaiting_password?
  validates_length_of :password, minimum: 6, if: :awaiting_password?
  validate :password_equals_to_confirmation, if: :awaiting_password?

  workflow do
    state :new do
      event :register, :transitions_to => :awaiting_confirmation
      event :defer, :transitions_to => :deferred
    end
    state :awaiting_confirmation do
      event :confirm, :transitions_to => :awaiting_verification
    end
    state :awaiting_verification do
      event :verify, :transitions_to => :awaiting_payment
    end
    state :awaiting_payment do
      event :confirm_payment, :transitions_to => :awaiting_password
    end
    state :awaiting_password do
      event :send_to_ds, :transitions_to => :done
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
    super((options || {}).merge({
      methods: [:inn, :name, :workflow_state]
    }))
  end

  # Sends notification about this registration to admin
  def notify_admin
    return if admin_notified?
    update_column(:admin_notified, true) if persisted?
    RegistrationMailer.admin_notification_email(self).deliver
  end

  # @return [Boolean] whether the company with specified OGRN is alredy exists in Siebel
  def siebel_company_exists?
    find_siebel_company(ogrn) ? true : false
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

    # Callback on transition from awaiting_password to done state.
    def send_to_ds
      uas_user = create_uas_user
      contact = Contact.find_by_integration_id(uas_user.user_id)
      person = create_sns_user(contact)
      account = find_siebel_company(ogrn) || create_siebel_company
      company = find_sns_company(person, account) || create_sns_company(person, account)
      User.create(siebel_id: contact.id, integration_id: contact.integration_id)
      uas_user.is_disabled = false
      uas_user.save
    rescue => e
      ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: 'Can not send data to DS' })
      logger.error "Can not send data to DS. #{e.message}"
      e.backtrace.each { |line| logger.error line }
      halt
    end

    # @return [Uas::User] new UAS user
    # @note It automatically creates Siebel user
    def create_uas_user
      user = Uas::User.new
      user.login = phone
      user.password = password
      user_info = retrieve_user_info_from_company
      user.first_name = user_info[:first_name] || 'Не определено'
      user.last_name = user_info[:last_name] || 'Не определено'
      user.patronymic_name = user_info[:patronymic_name] || 'Не определено'
      user.phone = phone
      user.is_disabled = true
      user.create
    end

    # @param contact [Contact] Siebel representation of the user
    # @return [Person] new SNS user
    def create_sns_user(contact)
      Ds::Sns.su do
        person = Person.new(id: contact.id, name: 'Не определено')
        person.save
        person
      end
    end

    # @param ogrn [String] OGRN of the company
    # @return [Account] Siebel company with specified OGRN
    # @return [nil] if nothing found
    def find_siebel_company(ogrn)
      Account.where(x_sbt_ogrn: ogrn).first
    end

    # @return [Account] new Siebel company
    def create_siebel_company
      account = Account.new
      account.full_name = company_name
      account.inn = inn
      account.ogrn = ogrn
      account.save
      account = Account.find_by_integration_id(account.siebel_integration_id) # Reload to get correct id
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
    def retrieve_user_info_from_company
      if ogrn.to_s.length == 15
        values = company_name.to_s.split(' ').select(&:present?).map(&:capitalize)
        { first_name: values[1], last_name: values[0], patronymic_name: values[2] }
      else
        {}
      end
    end
end
