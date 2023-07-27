class ApplicationController < ActionController::Base
    include ApplicationHelper
    include RabbitmqHelper
    include JwtHelper
    include SessionsHelper
    include TherapistHelper
    include UserHelper
    include ::GeocoderService
  
    protect_from_forgery with: :null_session
    before_action :configuration
  
    def testing
      render json: { status: 'RUNNING' }
    end
  
    def user_data
      current_user = User.find_by(id: 8)
      render json: { data: ::UserEntity.new(current_user) }
    end
  end
  