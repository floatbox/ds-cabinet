module Uas
  class LoginInfo < Uas::Base
    uas_attr :token
    attr_accessor :user

    def self.hydrate_resource(item)
      resource = super
      resource.user = User.hydrate_resource(item['User'])
      resource
    end
  end
end