require 'savon'

# Enable Savon logging for errors only
module Savon
  unless Savon.respond_to? :origin_client
    class << self
      alias_method :origin_client, :client
    end

    def self.client globals = {}, &block
      #globals.merge!(log_level: :error)
      globals.merge!(log: false) # disable logging completely
      self.origin_client(globals, &block)
    end
  end
end
