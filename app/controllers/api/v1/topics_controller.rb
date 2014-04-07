module API
  module V1

    class TopicsController < APIController
      before_action :set_user

      # GET /api/v1/topics
      def index
        @topics = Topic.all
        render json: @topics, status: :ok
      end

      # POST /api/v1/users/:user_id/topics
      def create
        @topic = @user.topics.build(topic_params)
        @topic.author = @current_user
        if @topic.save
          render json: @topic, status: :created, location: @topic
        else
          render json: @topic.errors, status: :unprocessable_entity
        end
      end

      private

        def set_user
          @user = User.find(params[:user_id]) if params[:user_id]
        end

        def topic_params
          params.fetch(:topic, {}).permit(:widget_type, :widget_options)
        end
    end

  end
end