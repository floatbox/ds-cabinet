class UsersController < ApplicationController
  layout 'chat'
  protect_from_forgery with: :null_session

  before_action :authenticate, only: [:update]
  before_action :authenticate_with_response, only: [:edit]

  def edit
    @user = current_user
    render layout: false
  end

  def update
    @user = current_user
    @user.assign_attributes(user_params)
    @result = @user.siebel.save
  end

  # POST /users/token
  def token
    uas_user = find_uas_user(params[:token])
    siebel_user = Contact.find_by_integration_id(uas_user.user_id)
    sns_user = Person.find(siebel_user.id)
    sns_company = Ds::Sns.as sns_user.id, 'siebel' do
      sns_user.companies.first
    end
    siebel_company = Account.find(sns_company.id)
    render json: { id: siebel_user.id,
                   name: [uas_user.first_name, uas_user.last_name].join(' '),
                   phone: uas_user.login,
                   ogrn: siebel_company.ogrn,
                   created_at: sns_user.created_at }
  rescue => exception
    logger.error "POST /users/token/:token error occured. #{exception.message}"
    head :internal_server_error
  end

  # POST /users/token_light
  # Lightweight version of `token` method
  def token_light
    uas_user = find_uas_user(params[:token])
    render json: { name: [uas_user.first_name, uas_user.last_name].join(' '),
                   phone: uas_user.login }
  rescue => exception
    logger.error "POST /users/token_light/:token error occured. #{exception.message}"
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

    def user_params
      params.require(:user).permit(:first_name, :last_name, :middle_name)
    end

end
