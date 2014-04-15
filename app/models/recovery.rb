class Recovery < ActiveRecord::Base
  include Workflow

  attr_accessor :password, :password_confirmation

  workflow do
    state :awaiting_verification do
      event :verify, transitions_to: :awaiting_password
    end
    state :awaiting_password do
      event :set_password, transitions_to: :done
    end
    state :done
  end

  validates :phone, presence: true, format: { with: /\A(\+[0-9]{11})\Z/i }
  validate :validate_phone_existance
  validates_presence_of :password, :password_confirmation, if: :awaiting_password?
  validate :password_equals_to_confirmation, if: :awaiting_password?

  # Remove symbols from the phone number
  def phone=(value)
    write_attribute(:phone, value.gsub('(', '').gsub(')', '').gsub(' ', '').gsub('-', ''))
  end

  private

    def validate_phone_existance
      errors.add(:phone, :does_not_exist) if phone.present? && !Uas::User.exist?(phone)
    end

    def password_equals_to_confirmation
      if password.present? && password_confirmation.present?
        errors.add(:password, :wrong_confirmation) unless password == password_confirmation
      end
    end

    def set_password
      if valid?
        siebel_user = Contact.find_by(email_addr: phone)
        return halt unless siebel_user
        user = Uas::User.new
        user.user_id = siebel_user.integration_id
        user.user_sys_name = 'siebel'
        halt unless user.recover_password(password)
      else
        halt
      end
    end

end
