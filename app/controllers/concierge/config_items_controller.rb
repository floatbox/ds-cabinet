class Concierge::ConfigItemsController < Concierge::ApplicationController
  layout 'chat'

  before_action :authenticate
  load_and_authorize_resource

  def index
  end

  def update
    @config_item.update_attributes(config_item_params)
    redirect_to concierge_config_items_url
  end

  private

    def config_item_params
      params.require(:config_item).permit(:value)
    end

end