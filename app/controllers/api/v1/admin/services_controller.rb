class Api::V1::Admin::ServicesController < ApplicationController
    before_action :authorized
    before_action :is_admin?
    
    def index
        Service.order(id: :asc)
            .tap { |q| q.where(name: params[:name]) if params[:name].present? }
            .tap { |q| q.where('price_per_hour >= ?', params[:price_per_hour_min]) }
            .tap { |q| q.where('price_per_hour <= ?', params[:price_per_hour_max]) }
            .tap { |q| q.where('minimum_duration >= ?', params[:minimum_duration]) }
            .tap { |q| return render json: { data: q }}
    end
    
    def create
      service = Service.new(param_services)
      if service.save
        return render json: {
          message: 'Service successfully created',
          service: service
        }, status: :created
      else
        return render json: {
          message: 'Service failed to be created',
          errors: service.errors
        }, status: :unprocessable_entity
      end
    end
    
    def update
      service = Service.find_by_id(params[:service_id])
      if service.nil?
        return render json: {
          message: 'Service not found.'
        }, status: :not_found
      end
    
      if service.update(param_services)
        return render json: {
          message: 'Service successfully updated',
          service: service
        }, status: :ok
      else
        return render json: {
          message: 'Failed to update service',
          errors: service.errors
        }, status: :unprocessable_entity
      end
    end
    
    def destroy
      service = Service.find_by_id(params[:service_id])
      if service.nil?
        return render json: {
          message: 'Service not found.'
        }, status: :not_found
      end
    
      service.destroy
      return head :no_content
    end
    
    private
    
    def param_services
      {
        name: params[:name],
        description: params[:description],
        price_per_hour: params[:price_per_hour],
        minimum_duration: params[:minimum_duration],
        image: params[:image]
      }
    end
end