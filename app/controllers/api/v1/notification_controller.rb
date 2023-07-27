class Api::V1::NotificationController < ApplicationController
  before_action :authorized

  def index
    notification = current_user.notifications.order(id: :desc)
    render json: notification.map { |notif| Api::V1::Entities::NotificationEntities.new(notif) }, status: :ok
  end

  def update
    notification = current_user.notifications.find_by_id(params[:id])
    if notification
      if notification.update(is_read: params[:read])
        render json: {
          message: "Notification successfully updated",
          data: {}
        }, status: :ok
      else
        render json: {
          message: "Failed to update notification",
          data: {}
        }, status: :unprocessable_entity
      end
    else
      render json: {
        message: "Notification not found",
        data: {}
      }, status: :not_found
    end
  end

  def destroy
    notification = current_user.notifications.find_by_id(params[:id])
    if notification
      if notification.destroy()
        render json: {
          message: "Notification successfully deleted",
          data: {}
        }, status: :ok
      else
        render json: {
          message: "Failed to delete notification",
          data: {}
        }, status: :unprocessable_entity
      end
    else
      render json: {
        message: "Notification not found",
        data: {}
      }, status: :not_found
    end
  end
end
