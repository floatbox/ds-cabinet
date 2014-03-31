class Concierge::TagsController < Concierge::ApplicationController
  layout 'chat'

  before_action :authenticate

  def index
    @tags = Topic.tag_counts_on(:tags)
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    redirect_to concierge_tags_url
  end

end