class SmsVerification < ActiveRecord::Base

  # Sends request for SMS code.
  # @param phone [String] user's phone number
  # @return [String] code that was sent via SMS
  # @return [false] if any errors occured
  def self.send_request(phone)
    Dsreda::Sms.send(phone, with_verification_code: true)
  end

end