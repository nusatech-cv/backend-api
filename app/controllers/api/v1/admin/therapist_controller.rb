class Api::V1::Admin::TherapistController < ApplicationController
    def index
        Therapist.order(id: :desc)
            .tap { |q| q.joins(:users).where(email: params[:email]) if params[:email].present? }
            .tap { |q| q.where(experience_years: params[:experience_years]) if params[:experience_years].present? }
            .tap { |q| q.where('working_hour >= ?', params[:working_hour_start]) if params[:working_hour_start].present? }
            .tap { |q| q.where('working_hour <= ?', params[:working_hour_end]) if params[:working_hour_end].present? }
            .tap { |q| q.where(gender: params[:gender]) if params[:gender].present? }
            .tap { |q| q.where(is_available: params[:is_available]) if params[:is_available].present? }
            .tap { |q| return render json: {
                data: q.map{ |t| Api::V1::Admin::Entities::TherapistEntities.new(t) }
            }}
    end

    def ratings
        therapist = Rating.where(therapist_id: params[:therapist_id])
        render json: therapist.map { |rating| Api::V1::Admin::Entities::RatingEntities.new(rating) }
    end
end
