class Concierge::SearchQueriesController < Concierge::ApplicationController
  layout 'concierge'

  before_action :authenticate
  before_action :set_user

  # GET /concierge/users/:user_id/search_queries
  def index
    authorize! :read, SearchQuery
    @search_queries = @user.search_queries.page(params[:page]).per(50)
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

end
