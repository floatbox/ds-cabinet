# Describes registration process.
# Registration has a state. States and transitions are described in `workflow` block below.
# Brief information about the states:
#   * new                     Registration is just created and not even saved
#   * awaiting_confirmation   It was saved to the database. Now it should be confirmed by user.
#   * awaiting_verification   It was confirmed. User should enter password and SMS code to verify if.
#   * verified                Everything is done, data was sent to UAS, SNS and Siebel.
#
class Registration < ActiveRecord::Base
  include Workflow

  attr_accessor :password

  validates_presence_of :phone, :ogrn
  validates_format_of :phone, with: /\A(\+[0-9]{11})\Z/i
  validates_format_of :ogrn, with: /\A([0-9]{13})\Z/i
  validate :company_exists, if: :new_record?
  validates_presence_of :password, if: :awaiting_verification?

  workflow do
    state :new do
      event :register, :transitions_to => :awaiting_confirmation
    end
    state :awaiting_confirmation do
      event :confirm, :transitions_to => :awaiting_verification
    end
    state :awaiting_verification do
      event :verify, :transitions_to => :verified
    end
    state :verified
  end

  def company
    @company ||= Ds::Spark::Company.where(ogrn: ogrn).first
  rescue
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
end
