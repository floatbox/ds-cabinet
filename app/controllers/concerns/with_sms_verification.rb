module WithSmsVerification

  # Generates new verification code: generates cookie and creates SmsVerification record in database.
  # @param phone [String] ehere to send SMS
  # @return [String] code if it was successfully sent
  # @return [false] if phone is invalid
  def generate_sms_verification_code(phone)
    code = SmsVerification.send_request(phone)
    if code
      SmsVerification.create(cookie: generate_cookie, phone: phone, code: code, attempts: 0)
      code
    else
      false
    end
  end

  # TODO: Some of this logic could be moved to Registration model validations.
  # @return [Boolean] whether verification was successful
  def with_sms_verification(phone)
    # Try to find SMS verification request
    sms_verification = SmsVerification.where({ cookie: cookie, phone: phone }).first

    # No SMS code sent yet.
    unless sms_verification
      generate_sms_verification_code(phone)
      false
    # SMS code was already sent
    else
      # SMS code is correct
      if sms_verification.code == params[:sms_verification_code]
        reset(sms_verification)
        true
      # SMS code is incorrect
      else
        sms_verification.attempts += 1
        sms_verification.save

        if sms_verification.attempts >= 3
          reset(sms_verification)
          generate_sms_verification_code(phone)
        end

        false
      end
    end
  end

  private

    # Generates new cookie to authorize the attempts to enter verification code
    # @return [String] generated code that is stored in cookies
    def generate_cookie
      cookies[:credit_request] = SecureRandom.hex(32)
    end

    # @return [String] new cookie for SMS verification or the existing one
    def cookie
      cookies[:credit_request] || generate_cookie
    end

    # Deletes cookie and sms verification temporary data
    def reset(sms_verification)
      cookies.delete(:credit_request)
      sms_verification.destroy
    end
end