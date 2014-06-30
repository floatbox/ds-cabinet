class Concierge::UsersController < Concierge::ApplicationController
  layout 'chat'

  before_action :authenticate
  load_and_authorize_resource

  # GET /concierge/users
  def index
    @users = @users.common.order('created_at DESC').page(params[:page]).per(10)
  end

  # GET /concierge/users/concierges
  def concierges
    authorize! :toggle_concierge, User
    @users = User.concierges.order('created_at DESC').page(params[:page]).per(10)
  end

  # GET /concierge/users/:id
  def edit
  end

  # PATCH /concierge/users/:id
  def update
    @user.assign_attributes(user_params)
    if @user.save && @user.siebel.save
      redirect_to concierge_users_url
    else
      render 'edit', alert: 'Не удалось сохранить'
    end
  end

  # GET /concierge/users/:id/attach_concierge
  def attach_concierge
  end

  # PATCH /concierge/users/:id/attach_concierge_update
  def attach_concierge_update
    if @user.update_attributes(user_attach_concierge_params)
      redirect_to concierge_users_url
    else
      render 'attach_concierge', alert: 'Не удалось назначить консьержа'
    end
  end

  # PATCH /concierge/users/:id/approve
  def approve
    @user.update_column(:approved, true)
    redirect_to concierge_users_url
  end

  # PATCH /concierge/users/:id/disapprove
  def disapprove
    @user.update_column(:approved, false)
    redirect_to concierge_users_url
  end

  # PATCH /concierge/users/:id/toggle_concierge
  def toggle_concierge
    @user.toggle(:is_concierge) unless @user.id == current_user.id
    if @user.save
      redirect_to concierges_concierge_users_url
    else
      redirect_to concierge_users_url
    end
  end

  # GET /concierge/users/:id/new_widget
  def new_widget
    render layout: false
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :middle_name, :tax_treatment)
    end

    def user_attach_concierge_params
      params.require(:user).permit(:concierge_id)
    end


end