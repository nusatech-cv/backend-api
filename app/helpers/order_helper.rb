module OrderHelper
    def order_params
      {
        user_id: current_user.id,
        service_id: params[:service_id],
        therapist_id: params[:therapist_id],
        appointment_date: params[:appointment_date],
        appointment_duration: params[:appointment_duration],
        location: parsing_location_order,
        note: params[:note],
        order_status: 'waiting_confirmation'
      }
    end
  
    def ratings_params(order)
      {
        order_id: params[:id],
        therapist_id: order.therapist_id,
        rating: params[:rating],
        note: params[:note]
      }
    end
  
    def validation!
      service = Service.find_by_id(params[:service_id])
      if service && service.minimum_duration > params[:appointment_duration]
        return {
          status: false,
          message: "Appointment duration is less than the minimum service duration, minimum is #{service.minimum_duration}"
        }, status: :unprocessable_entity
      end
    end
  
    def validation_status!(order)
      status = params[:status].to_s.downcase
      return true if current_user.role == 'User' && Order::USER_UPDATE.include?(status)
      return true if current_user.role == 'Therapist' && Order::THERAPIST_UPDATE.include?(status)
      false
    end
  
    def parsing_location_order
      return nil unless params[:location]
       
      params_location = JSON.parse(params[:location])
      x, y = params_location['x'].to_f, params_location['y'].to_f
  
      "POINT(#{y} #{x})"
    end
end
  