class SmsVerification < ActiveRecord::Base

  # Sends request for SMS code.
  # @param phone [String] user's phone number
  # @return [String] code that was sent via SMS
  # @return [false] if any errors occured
  def self.send_request(phone)
    request_body = build_request(phone).to_param
    client = build_client(Rails.configuration.sms_gateway)
    client.http_post(request_body)
    # client.response_code == 200 ? client.body_str : false
    # For testing purposes now there is hardcoded verification code.
    # Remove it before deploying to production.
    client.response_code == 200 ? '111111' : false
  end

  private

    # Builds curl client for SMS verification request
    # @param url [String] URL of SMS gateway
    # @return [Curl::Easy] curl client
    def self.build_client(url)
      client = Curl::Easy.new(url) do |curl|
        curl.ssl_verify_peer = false
        curl.ssl_verify_host = false
      end
    end

    # Builds body of SMS verification request
    # @param phone [String] user's phone number
    # @return [Hash] body of SMS verification request
    def self.build_request(phone = '')
      { 'WithVerificationCode' => true,
        'ToPhoneNumber' => phone,
        'Text' => 'Код: #code#' }
    end

end