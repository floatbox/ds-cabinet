class TopicsController < ApplicationController
  layout 'chat'

  before_action :authenticate, only: [:index, :show, :create, :update]
  before_action :authenticate_with_response, only: [:new, :edit]
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

end