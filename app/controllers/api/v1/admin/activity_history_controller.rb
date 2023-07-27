class Api::V1::Admin::ActivityHistoryController < ApplicationController
    def index
        ActivityHistory.order(id: :desc)
            .tap { |q| q.where(user_id: params[:user_id]) if params[:user_id].present? }
            .tap { |q| q.where(activity_type: params[:activity_type]) if params[:activity_type].present? }
            .tap { |q| q.where(ip_address: params[:ip_address]) if params[:ip_address].present? }
            .tap { |q| return render json: {
                activity_history: q.map { |ac| Api::V1::Admin::Entities::ActivityHistoryEntities.new(ac)
            } } }
    end

    def show
        history = ActivityHistory.find_by_id(params[:id])
        return render json: { activity: Api::V1::Admin::Entities::ActivityHistoryEntities.new(history) }
    end
end
