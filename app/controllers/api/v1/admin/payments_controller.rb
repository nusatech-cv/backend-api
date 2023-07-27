class Api::V1::Admin::PaymentsController < ApplicationController
    def index
        Payment.order(id: :desc)
            .tap { |q| q.where(user_id: params[:user_id]) if params[:user_id].present? }
            .tap { |q| q.where(payment_method: params[:payment_method]) if params[:payment_method].present? }
            .tap { |q| q.where(payment_status: params[:payment_status]) if params[:payment_status].present? }
            .tap { |q| q.where(to_account: params[:to_account]) if params[:to_account].present? }
            .tap { |q| q.where(sender_account: params[:sender_account]) if params[:sender_account].present? }
            .tap { |q| q.where(order_id: params[:order_id]) if params[:order_id].present? }
            .tap { |q| render json: { total_revenue: q.sum(:amount_paid), payments: q.map { |pay| Api::V1::Admin::Entities::PaymentEntities.new(pay) } } }
    end
end
