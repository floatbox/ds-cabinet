class Concierge::TopicsController < Concierge::ApplicationController
  layout 'chat'

  before_action :set_user

  before_action :authenticate
  authorize_resource

  def index
    @topics = @user ? @user.topics : Topic
    @topics = @topics.tagged_with(params[:tag]) if params[:tag]
    @topics = @topics.page(params[:page]).per(10)
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = @user.topics.build
    @topic.author_id = current_user.id
    render layout: false
  end

  def create
    @topic = @user.topics.build(topic_params)
    @topic.author_id = current_user.id
    @topic.save
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

    def set_user
      @user = User.find(params[:user_id]) if params[:user_id]
    end

    def topic_params
      params.require(:topic).permit(:text, :tag_list)
    end
end