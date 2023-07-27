include OrderHelper
include PaymentHelper
include SessionsHelper

class Api::V1::OrdersController < ApplicationController
  before_action :authorized
  before_action :is_user?, only: [:create]

  def index
    begin
        sort_by = params[:sort_by]
        order_by = params[:sort_dir]
        filter_user = current_user.role == "User" ? "user_id = #{current_user.id}" : "therapist_id = #{current_user.therapist.id}"
        orders = Order.select('*')
                        .select(query_arel_distance.as("distance"))
                        .where(filter_user)
                        .order("#{sort_by} #{order_by}")

        render json: orders.map { |order| Api::V1::Entities::OrderWithServiceEntities.new(order) }
    rescue StandardError => e
        render json: [], status: :ok
    end
  end

  def show
    filter_user = current_user.role == "User" ? current_user.id : current_user.therapist&.id
    puts filter_user
    begin
      order = Order.select("*")
                   .select(query_arel_distance.as("distance"))
                   .where('(user_id = ? OR therapist_id = ?)', current_user.id, current_user.id)
                   .find_by({ id: params[:id] })
      if order.nil?
        render json: { message: 'Order not found' }, status: :not_found
      else
        render json: Api::V1::Entities::OrderDetailEntities.new(order)
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: "Order not found" }, status: 404
    rescue StandardError => e
      render json: { message: "Failed to retrieve order details: #{e.message}" }, status: :internal_server_error
    end
  end

  def create
    duration = Service.find_by_id(params[:service_id])
    if duration.minimum_duration > params[:appointment_duration]
      return render json: {
        status: false,
        message: "Appointment duration less than service duration, minimum is #{duration.minimum_duration}"
      }, status: :unprocessable_entity
    end

    order = Order.new(order_params)

    begin
      if order.save
        log_activity_success(current_user.id, 'New Order Created')
        render json: {
          message: "Order successfully Updated",
          data: Api::V1::Entities::OrderEntities.new(order)
        }, status: :created
      else
        render json: {
          message: 'User failed to create order',
          data: order.errors
        }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: "Failed to create order: #{e.message}" }, status: :internal_server_error
    end
  end

  def order_status_updated
    target_order = Order.find_by_id(params[:id])
    
    if current_user.role == 'User' && target_order.user_id != current_user.id
      return render json: {
        message: "User does not have permission to update this order"
      }, status: :forbidden
    end

    if current_user.role == 'Therapist' && target_order.therapist_id != current_user.therapist.id
      return render json: {
        message: "Therapist does not have permission to update this order"
      }, status: :forbidden
    end
    unless validation_status!(target_order)
      log_activity_failed(current_user.id, 'Failed update order status')
      return render json: {
        message: "#{current_user.role} invalid status updated"
      }, status: :unprocessable_entity
    end

    begin
      if target_order.update(order_status: params[:status])
        if params[:status] == 'appointment_start'
          target_order.update(appointment_start_at: Time.now)
        elsif params[:status] == 'done'
          target_order.update(appointment_end: Time.now)
        end
        response_code = params[:status] == 'cancel' ? :ok : :created

        render json: {
          message: "#{current_user.role} successfully updated order",
          data: Api::V1::Entities::OrderEntities.new(target_order)
        }, status: response_code
      else
        render json: {
          message: "#{current_user.role} failed update order",
          data: target_order.errors
        }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: "Failed to update order status: #{e.message}" }, status: :internal_server_error
    end
  end

  def order_payments
    order = Order.find_by_id(params[:id])
    unless validate_payment
      return render json: {
        message: "Invalid payment method",
        data: Payment::PAYMENT_LIST
      }, status: :unprocessable_entity
    end

    if ['expire', 'done', 'cancel'].include?(order.order_status)
      return render json: {
        message: "Order cannot be paid. Order status is already #{order.order_status}",
        data: {}
      }, status: :unprocessable_entity
    end
    payment = Payment.new(payment_params(order))

    begin
      if payment.save
        render json: {
          message: "#{current_user.role} successfully created payment",
          data: payment
        }, status: :created
      else
        render json: {
          message: "#{current_user.role} failed to create payment",
          data: payment.errors
        }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: "Failed to create payment: #{e.message}" }, status: :internal_server_error
    end
  end

  def order_ratings
    order = Order.find_by_id(params[:id])

    unless order.order_status == 'done'
      return render json: {
        message: "Rating can only be given for orders with 'done' status",
        data: {}
      }, status: :unprocessable_entity
    end
    rating = current_user.ratings.new(ratings_params(order))

    begin
      if rating.save
        log_activity_success(current_user.id, 'User Rating created')
        render json: {
          message: "#{current_user.role} successfully created ratings",
          data: Api::V1::Entities::RatingsServiceEntities.new(rating)
        }, status: :created
      else
        render json: {
          message: "#{current_user.role} failed to create ratings",
          data: rating.errors
        }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: "Failed to create rating: #{e.message}" }, status: :internal_server_error
    end
  end
end
