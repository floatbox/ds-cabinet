module Dsreda
  class Sms
    # Sends request for SMS code.
    # @param phone [String] user's phone number
    # @param options [Hash] options
    # @return [String] code that was sent via SMS
    # @return [false] if any errors occured
    def self.send(phone, options = {})
      request_body = build_request(phone, options).to_param
      client = build_client(Rails.configuration.sms_gateway)
      client.http_post(request_body)
      client.response_code == 200 ? client.body_str : false
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

      # Builds body of the request to API
      # @param phone [String] phone number
      # @param options [Hash] options
      # @option options [String] :text SMS text
      # @option options [Boolean] :with_verification_code Whether service should generate verification code
      # @return [Hash] body of the request to API
      def self.build_request(phone, options = {})
        { 'WithVerificationCode' => !!options[:with_verification_code],
          'ToPhoneNumber' => phone,
          'Text' => options[:text] || 'Код: #code#' }
      end
  end
end