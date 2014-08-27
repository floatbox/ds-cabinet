module Ds
  module Pim

  class Query
    # Executes query.
    # @param url [String] request URL
    # @param options [Hash] query options
    # @option options [Hash] :request request body
    # @option options [Symbol] :method HTTP method (:get, :post, :patch, :put, :delete). :get by default
    def self.execute(url, options = {})
      request = options[:request] || {}
      method = options[:method] || :get

      url += '?' + request.to_param if method == :get && !request.empty?
      client = client(url)

      case method
        when :post
          client.post(request.to_json)
        when :put
          client.post_body = Curl::postalize(JSON.dump(request))
          client.http(:PUT)
        else
          client.get
      end

      if Rails.configuration.pim_query_log
        puts "Request #{method} #{url}"
        puts request.inspect
        puts "Response code: #{client.response_code}"
        puts client.body_str
      end

      { code: client.response_code,
        body: client.body_str }
    end

    private

      # Creates CURL client instance that is set up to send request to PIM.
      # @return [Curl::Easy] CURL client
      def self.client(url)
        url = "#{Rails.configuration.pim_url}/#{url}"
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Accept'] = 'application/json'

        Curl::Easy.new(url) do |curl|
          curl.headers = headers
          curl.use_ssl = 1
          curl.verbose = Rails.configuration.pim_curl_verbose
          curl.cert = Rails.configuration.pim_sertificate
          curl.ssl_verify_peer = false
          curl.ssl_verify_host = false
        end
      end

    end

  end
end
