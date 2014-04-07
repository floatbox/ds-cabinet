module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body, symbolize_names: true)
    end

    def token_header(token)
      ActionController::HttpAuthentication::Token.encode_credentials(token)
    end
  end
end