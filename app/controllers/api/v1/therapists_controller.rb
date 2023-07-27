class Api::V1::TherapistsController < ApplicationController
    before_action :authorized, :is_therapist?, except: [:index, :detail]

    def index
        therapist = Therapist.select('*')
                    .select(query_arel_distance.as("distance"))
                    .order(query_arel_order)

        render json: therapist.map { |ther| Api::V1::Entities::TherapistWithFullInfoEntities.new(ther) }
    end

    def show
        target_therapist = Therapist.select('*')
                    .select(query_arel_distance.as("distance"))
                    .find_by(id: params[:id])
        
        return render json: Api::V1::Entities::TherapistWithFullInfoEntities.new(target_therapist, location: location)
    end

    def profile
        return render json: Api::V1::Entities::TherapistWithServiceEntities.new(current_user.therapist)
    end

    def create
        therapist = Therapist.new(therapist_params)
        if therapist.save
            update_user_name
            log_activity_success(current_user.id, 'Registered Therapist')
            return render json: {
                message: 'user successfully registered to therapist',
                data: therapist
            }, status: :created
        end

        return render json: {
            message: 'user failed registerd to therapist',
            data: therapist.errors
        }, status: :unprocessable_entity
    end

    def service
        therapist = current_user.therapist
        service_id = params[:service_id].to_i
        if therapist.therapist_services.exists?(service_id: service_id)
        return render json: {
            message: 'Service ID is already associated with this therapist',
            data: therapist.therapist_services.find_by(service_id: service_id)
        }, status: :ok
        end
        
        service = TherapistService.new({therapist_id: current_user.therapist.id, service_id: params[:service_id]})
        if service.save
            return render json: {
                message: 'Therapist successfully add services',
                data: service
            }, status: :created
        end

        return render json: {
                message: 'Therapist failed to add services',
                data: service.errors
            }, status: :unprocessable_entity
    end

    def update
        if params[:user_id] != current_user.id
            return render json: {
              message: "You are not authorized to update this therapist"
            }, status: :unauthorized
        end

        if Therapist.update(therapist_params)
            update_user_name
            log_activity_success(current_user.id, 'update therapist data')
            return render json: {
                message: 'User therapist successfully update',
            }, status: :created
        end

        return render json: {
                message: 'User therapist failed to update',
                data: therapist.errors
            }, status: :unprocessable_entity
    end

    def service_delete
        service = TherapistService.find_by(therapist_id: current_user.therapist.id, service_id: params[:service_id])
        if service.nil?
            return render json: {
              message: 'Service not found',
            }, status: :not_found
        end
        
        if service.destroy
            return render json: {
                    message: 'Therapist successfully update services',
                    data: {}
                }, status: :created
        end

        return render json: {
                message: 'User therapist failed to update',
                data: therapist.errors
            }, status: :unprocessable_entity
    end

    def ratings
        Therapist.ratings
                .tap { |q| q.where('rating >= ? ', params[:rating]) if params[:rating].present? }
                .tap { |q| q.where(order_id: params[:order]) if params[:order].present? }
                .tap { |q| q.where(user_id: params[:user]) if params[:user].present? }
                .tap { |q| render json: q.map { |rat| Api::V1::Entities::RatingsEntities.new(rat) } }
    end

    def payment_order
        payment = Payment.joins(:order).where(order: {therapist_id: current_user.therapist.id})
        return render json: payment.map { |pay| Api::V1::Entities::TherapistPaymentEntities.new(pay) }
    end

    private
    def update_user_name
        user = User.find_by(id: current_user.id)
        user.update({first_name: params[:first_name], last_name: params[:last_name]})
    end
end
