class Api::V1::Admin::UsersController < Api::V1::Admin::ApplicationController
    def index
        User.order(created_at: :asc)
            .tap { |q| q.where(email: params['email']) if params[:email].present? }
            .tap { |q| q.where(role: params['role']) if params[:role].present? }
            .tap { |q| q.where(google_id: params['google_id']) if params[:role].present? }
            .tap { |q| render json: {
                users: q.map{ |r| Api::V1::Admin::Entities::UserEntities.new(r) }
            }}
    end
  
    def update
      target_user = User.find_by_id(params[:user_id])
      if target_user.nil?
        return render json: {
          message: "User not found"
        }, status: :not_found
      end
  
      if target_user.update(param_user)
        return render json: {
          message: "User successfully updated",
          service: target_user
        }, status: :ok
      else
        return render json: {
          message: "Failed to update user. Invalid params."
        }, status: :unprocessable_entity
      end
    end
  
    def show
      target_user = User.find_by(id: params['id'])
      if target_user.nil?
        return render json: {
          message: "User not found"
        }, status: :not_found
      end
  
      return render json: Api::V1::Admin::Entities::UserEntities.new(target_user)
    end
  
    private
  
    def param_user
      {
        avatar: params['avatar'],
        role: params['role'],
        first_name: params['first_name'],
        last_name: params['last_name']
      }
    end
  end
  