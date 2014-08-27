module Ds
  module Cart

  class Query
    # Executes query.
    # @param url [String] request URL
    # @param options [Hash] query options
    # @option options [Hash] :request request body
    # @option options [Symbol] :method HTTP method (:get, :post, :patch, :put, :delete). :get by default
    def self.execute(url, options = {})
      request = options[:request] || {}
      method = options[:method] || :get

      if request.is_a?(Hash)
        url += '?' + request.to_param if (method == :get || method == :delete) && !request.empty?
      else
        url += '/' + request.to_s
      end
      client = client(url)

      case method
        when :post
          client.post(request.to_json)
        when :delete
          client.http(:DELETE)
        when :put
          client.post_body = Curl::postalize(JSON.dump(request))
          client.http(:PUT)
        else
          client.get
      end

      if Rails.configuration.cart_query_log
        puts "Request #{method} #{url}"
        puts request.inspect
        puts "Response code: #{client.response_code}"
        puts client.body_str
      end

      { code: client.response_code,
        body: client.body_str }
    end

    private

      # Creates CURL client instance that is set up to send request to CART.
      # @return [Curl::Easy] CURL client
      def self.client(url)
        url = "#{Rails.configuration.cart_url}/#{url}"
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Accept'] = 'application/json'

        Curl::Easy.new(url) do |curl|
          curl.headers = headers
          curl.use_ssl = 1
          curl.http_auth_types = :basic
          curl.username = Rails.configuration.cart_merchant_id
          curl.password = Rails.configuration.cart_merchant_password

          curl.verbose = Rails.configuration.cart_curl_verbose
          curl.cert = Rails.configuration.cart_sertificate
          curl.ssl_verify_peer = false
          curl.ssl_verify_host = false
        end
      end

    end

  end
end
