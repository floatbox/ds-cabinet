module API
  module V1
    class TopicsController < APIController
      def index
        @topics = Topic.all
        render json: @topics, status: 200
      end
    end
  end
end