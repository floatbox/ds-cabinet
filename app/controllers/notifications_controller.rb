class NotificationsController < ApplicationController
  def show
    @notification = current_user.notifications.where(id: params[:id]).first
    if @notification
      @notification.update_column(:read_at, Time.now)
      redirect_to @notification.data[:link]
    else
      redirect_to root_url
    end
  end
end