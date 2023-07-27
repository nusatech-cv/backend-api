class Api::V1::ServicesController < ApplicationController
  def index
      begin
        services = Service.order(id: :asc)
  
        services = services.where(minimum_duration: params[:minimum_duration]) if params[:minimum_duration].present?
        services = services.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
        services = services.where('price_per_hour >= ?', params[:price_per_hour_from]) if params[:price_per_hour_from].present?
        services = services.where('price_per_hour <= ?', params[:price_per_hour_to]) if params[:price_per_hour_to].present?
  
        render json: services.map { |service| Api::V1::Entities::ServiceEntities.new(service) }
  
      rescue StandardError => e
        render json: { error: 'Failed to fetch services', details: e.message }, status: :unprocessable_entity
      end
    end
end
  