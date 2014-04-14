module Uas

  # User representation in UAS service.
  class User < Uas::Base

    uas_attr :user_id, :user_sys_name, :login, :first_name, :last_name, :is_disabled
    attr_accessor :password, :patronymic_name, :country, :phone

    # Authenticates user by login/password.
    # @return [LoginInfo] login info with token and logged in user if credentials are correct
    # @raise [InvalidCredentials] if credentials are invalid
    # @raise [InternalError] if UAS did not response or any other errors occured
    def self.login(login, password)
      url = "user/login/?"
      request = { login: login, password: password }
      response = Uas::Query.execute(url, request: request, method: :post)

      case response[:code]
      when 200 then Uas::LoginInfo.hydrate_resource(JSON::parse(response[:body]))
      # Actually UAS raises 2 types of errors:
      #   * InvalidCredentialsFault
      #   * DataObjectNotFoundFault
      # But it's better to raise the same error for both situations.
      when 400 then raise InvalidCredentials, response[:body]
      else raise InternalError, response[:body]
      end
    end

    # Checks existance of UAS user
    # This method just tries to sign in with incorrect password and parses response from UAS.
    # @return [Boolean] whether user exists
    def self.exist?(login)
      url = "user/login/?"
      request = { login: login, password: SecureRandom.hex(32) }
      response = Uas::Query.execute(url, request: request, method: :post)
      if response[:code] == 400
        json = JSON::parse(response[:body])
        return false if json['__type'] == 'DataObjectNotFoundFault'
      end
      true
    end

    # @param token [String] authentication token
    # @return [Uas::User] user that was found by this token
    # @raise [InvalidCredentials] if user was not found
    # @raise [InternalError] if UAS did not response or any other errors occured
    def self.find_by_token(token)
      url = 'user/token/?'
      request = { token: token }
      response = Uas::Query.execute(url, request: request, method: :post)
      case response[:code]
      when 200 then Uas::User.hydrate_resource(JSON::parse(response[:body]))
      when 400 then raise InvalidCredentials, response[:body]
      else raise InternalError, response[:body]
      end
    end

    # Creates new user in UAS
    # @return [Uas::User] created user
    # @raise [InvalidArguments] if user was not created because of invalid data
    # @raise [InternalError] if UAS did not response or any other errors occured
    def create
      response = Uas::Query.execute('user/?', request: create_data, method: :post)
      case response[:code]
      when 200 then Uas::User.hydrate_resource(JSON::parse(response[:body]))
      when 400 then raise InvalidArguments, response[:body]
      else raise InternalError, response[:body]
      end
    end

    # Updates user info in UAS
    # @return [Uas::User] updated user
    # @raise [InvalidArguments] if user was not updated because of invalid data
    # @raise [InternalError] if UAS did not response or any other errors occured
    def save
      url = "user/#{user_sys_name}/#{user_id}/?"
      response = Uas::Query.execute(url, request: update_data, method: :put)
      case response[:code]
      when 200 then self
      when 400 then raise InvalidArguments, response[:body]
      else raise InternalError, response[:body]
      end
    end

    # Changes user's password
    # @param old_password [String] old password
    # @param new_password [String] new password
    # @return [Boolean] whether password was successfully changed
    def change_password(old_password, new_password)
      url = "user/#{user_sys_name}/#{user_id}/password/?"
      request = { oldPassword: old_password, newPassword: new_password }
      response = Uas::Query.execute(url, request: request, method: :put)
      case response[:code]
      when 200 then true
      else false
      end
    end

    # Changes user's password without confirmation of the old one.
    # @param new_password [String] new password
    # @return [Boolean] whether password was successfully changed
    def recover_password(new_password)
      url = "user/#{user_sys_name}/#{user_id}/recovery/?"
      request = { newPassword: new_password }
      response = Uas::Query.execute(url, request: request, method: :put)
      case response[:code]
      when 200 then true
      else false
      end
    end

    private

      def create_data
        { 'Login' => login,
          'Password' => password,
          'FirstName' => first_name,
          'LastName' => last_name,
          'PatronymicName' => patronymic_name,
          'Country' => country,
          'Phone' => phone,
          'IsDisabled' => is_disabled }
      end

      def update_data
        { 'FirstName' => first_name,
          'LastName' => last_name,
          'IsDisabled' => is_disabled }
      end

  end
end