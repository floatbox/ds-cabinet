class UsersController < ActionController::Base

  # POST /users/token/:token
  def token
    uas_user = find_uas_user(params[:token])
    siebel_user = Contact.find_by_integration_id(uas_user.user_id)
    sns_user = Person.find(siebel_user.id)
    sns_company = Ds::Sns.as sns_user.id, 'siebel' do
      sns_user.companies.first
    end
    siebel_company = Account.find(sns_company.id)
    response = { id: siebel_user.id,
                 name: [uas_user.first_name, uas_user.last_name].join(' '),
                 phone: uas_user.login,
                 ogrn: siebel_company.ogrn,
                 created_at: sns_user.created_at }
    render json: response
  rescue => exception
    logger.error "POST /users/token/:token error occured. #{exception.message}"
    head :internal_server_error
  end

  private

    # @return [Uas::User] user with specified token
    # @return [nil] if user was not found
    def find_uas_user(token)
      Uas::User.find_by_token(token)
    rescue Uas::Error
      nil
    end

end
