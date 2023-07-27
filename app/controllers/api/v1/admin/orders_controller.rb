class Api::V1::Admin::OrdersController < ApplicationController
    def index
        Order.order(id: :desc)
            .tap { |q| q.where(user_id: params[:user_id]) if params[:user_id].present? }
            .tap { |q| q.where(order_status: params[:order_status]) if params[:order_status].present? }
            .tap { |q| q.where(therapist_id: params[:therapist_id]) if params[:therapist_id].present? }
            .tap { |q| q.where(service_id: params[:service_id]) if params[:service_id].present? }
            .tap { |q| return render json: {
                orders: q.map { |order| Api::V1::Admin::Entities::OrderEntities.new(order)}
            }}
    end

    def show
        order = Order.find_by_id(params[:id])
        return render json: { order: Api::V1::Admin::Entities::OrderDetailEntities.new(order) }
    end
end
