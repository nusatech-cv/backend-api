class Api::V1::UsersController < ApplicationController
    before_action :authorized
  
    def profile
      user_entity = current_user.role == 'Therapist' ? Api::V1::Entities::UserWithFullInfoEntities.new(current_user) : Api::V1::Entities::UserEntities.new(current_user)
      return render json: { data: user_entity }
    end
   
    def role
      if current_user.role.present? || params[:role].nil?
        return render json: {
          message: "User role cannot be updated",
          data: {}
        }, status: :unprocessable_entity
      end
      
      if current_user.update(role: params[:role])
        log_activity_success(current_user.id, 'user role update')
        return render json: {
          message: "User successfully updated",
          data: {}
        }, status: :ok
      else
        return render json: {
          message: "User failed to update. Params are null or invalid.",
        }, status: :unprocessable_entity
      end
    end
  
    def registration_token
      token = params[:registration_token]
      if current_user.update(token_device: token)
        return render json: {
          message: "Registration token is updated successfully",
          data: {}
        }, status: :ok
      else
        return render json: {
          message: "Failed to update registration token. Params are null or invalid.",
        }, status: :unprocessable_entity
      end
    end

    def activity
        activity = ActivityHistory.where(user_id: current_user.id)
        return render json: activity.map { |ac| Api::V1::Entities::ActivityHistoryEntities.new(ac) }
    end
  end
  