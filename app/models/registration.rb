# Describes registration process.
# Registration has a state. States and transitions are described in `workflow` block below.
# Brief information about the states:
#   * new                     Registration is just created and not even saved
#   * awaiting_confirmation   It was saved to the database. Now it should be confirmed by user.
#   * awaiting_verification   It was confirmed. User should enter SMS code to verify it.
#   * awaiting_password       It was verified. User should enter password.
#   * done                    Everything is done, data was sent to UAS, SNS and Siebel.
#
class Registration < ActiveRecord::Base
  include Workflow

  attr_accessor :password, :password_confirmation

  validates_presence_of :phone, :ogrn
  validates_format_of :phone, with: /\A(\+[0-9]{11})\Z/i
  validates_format_of :ogrn, with: /\A([0-9]{13})\Z/i
  validate :company_exists, if: :new_record?
  validates_presence_of :password, :password_confirmation, if: :awaiting_password?
  validate :password_equals_to_confirmation, if: :awaiting_password?

  workflow do
    state :new do
      event :register, :transitions_to => :awaiting_confirmation
    end
    state :awaiting_confirmation do
      event :confirm, :transitions_to => :awaiting_verification
    end
    state :awaiting_verification do
      event :verify, :transitions_to => :awaiting_password
    end
    state :awaiting_password do
      event :send_to_ds, :transitions_to => :done
    end
    state :done
  end

  def company
    @company ||= Ds::Spark::Company.where(ogrn: ogrn).first
  rescue => e
    logger.error "Can not find company in Spark. #{e.message}"
    nil
  end

  def user
    @user = { phone: phone }
  end

  def inn
    company.try(:inn)
  end

  def name
    company.try(:name)
  end

  def region
    company.try(:region_code)
  end

  def as_json(options = {})
    super((options || {}).merge({
      methods: [:inn, :name, :region]
    }))
  end

  private

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
      contact = Contact.find_by_integration_id(uas_user['UserId'])
      person = create_sns_user(contact)
      account = create_siebel_company
      company = create_sns_company(contact, account)
    rescue => e
      logger.error "Can not send data to DS. #{e.message}"
      halt
    end

    # @return [Uas::User] new UAS user
    # @note It automatically creates Siebel user
    def create_uas_user
      user = Uas::User.new
      user.login = phone
      user.password = password
      user.first_name = 'Не определено'
      user.last_name = 'Не определено'
      user.phone = phone
      user.create
    end

    # @param contact [Contact] Siebel representation of the user
    # @return [Person] new SNS user
    def create_sns_user(contact)
      Ds::Sns.su do
        Person.new(id: contact.id, name: 'Не определено').save
      end
    end

    # @return [Account] new Siebel company
    def create_siebel_company
      account = Account.new
      account.full_name = company.name
      account.inn = inn
      account.ogrn = ogrn
      account.save
      account = Account.find_by_integration_id(account.siebel_integration_id) # Reload to get correct id
    end

    # @param contact [Contact] contact that should be the admin of the company
    # @param account [Account] Siebel representation of the company
    # @return [Company] new SNS company
    # @note Contact automatically becomes the admin of the account
    def create_sns_company(contact, account)
      Ds::Sns.as contact.id, 'siebel' do
        Company.new(id: account.id, name: account.full_name).save
      end
    end
end
