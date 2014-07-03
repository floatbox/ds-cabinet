module Uas

  # Wrapper for sending requests to UAS service.
  class Query

    # Executes query.
    # @param url [String] request URL
    # @param options [Hash] query options
    # @option options [Hash] :request request body
    # @option options [Symbol] :method HTTP method (:get, :post, :patch, :put, :delete). :get by default
    def self.execute(url, options = {})
      request = options[:request] || {}
      method = options[:method] || :get

      client = client(url)

      case method
      when :post
        client.post(request.to_json)
      when :put
        client.post_body = Curl::postalize(JSON.dump(request))
        client.http(:PUT)
      else client.get
      end

      if Rails.configuration.uas_query_log
        Rails.logger.info "Request #{method} #{url}"
        Rails.logger.info request.inspect
        Rails.logger.info "Response code: #{client.response_code}"
        Rails.logger.info client.body_str.mb_chars
      end
      
      { code: client.response_code,
        body: client.body_str }
    end

    private

      # Creates CURL client instance that is set up to send request to UAS.
      # @return [Curl::Easy] CURL client
      def self.client(url)
        url = "#{Rails.configuration.uas_url}/#{url}"

        Curl::Easy.new(url) do |curl|
          curl.use_ssl = 1
          curl.cert = Rails.configuration.uas_sertificate
          curl.ssl_verify_peer = false
          curl.ssl_verify_host = false
        end
      end
  end
end