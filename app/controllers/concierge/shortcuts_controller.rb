class Concierge::ShortcutsController < Concierge::ApplicationController
  layout 'chat'

  before_action :authenticate
  before_filter :new_shortcut, only: :create
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @shortcut.save
      redirect_to concierge_shortcuts_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @shortcut.update_attributes(shortcut_params)
      redirect_to concierge_shortcuts_url
    else
      render 'edit'
    end
  end


  private

    def shortcut_params
      params.require(:shortcut).permit(:question, :answer)
    end

    def new_shortcut
      @shortcut = Shortcut.new(shortcut_params)
    end

end