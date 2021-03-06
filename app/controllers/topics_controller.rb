class TopicsController < ApplicationController
  layout 'chat'

  before_action :authenticate, only: [:index, :show, :create, :update]
  before_action :authenticate_with_response, only: [:new, :edit]
  before_action :filter_concierge
  before_action :has_paid_access
  authorize_resource

  def index
    @topics = current_user.topics.page(params[:page]).per(10)
    @topics = @topics.tagged_with(params[:tag]) if params[:tag]
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = current_user.topics.build
    render layout: false
  end

  def create
    @topic = current_user.topics.create(topic_params)
  end

  def edit
    @topic = Topic.find(params[:id])
    render layout: false
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(topic_params)
  end

  private

    def topic_params
      params.require(:topic).permit(:text)
    end

    # Do not allow to access these pages for concierge
    def filter_concierge
      redirect_to url_for(controller: 'concierge/topics', action: params[:action]) if current_user.try(:is_concierge?)
    end

end
