module ApplicationHelper
    def log_activity_success(user, activity_type)
      log_activity(user, activity_type, 'success')
    end
  
    def log_activity_failed(user, activity_type)
      log_activity(user, activity_type, 'failed')
    end
  
    def log_activity(user, activity_type, result)
      ActivityHistory.create(build_activity_history(user, activity_type, result))
    end
  
    def build_activity_history(user, activity_type, result)
      Rails.logger.warn user.inspect
      {
        user_id: user,
        activity_type: activity_type,
        location: parsing_header_location,
        ip_address: request.headers['X-Forwarded-For'] || request.remote_ip,
        device_info: request.headers['User-Agent'],
        result: result
      }
    end
  
    def parsing_header_location
      raw_location = JSON.parse(request.headers['x-user-location'])
      return "POINT(#{raw_location['y'].to_f} #{raw_location['x'].to_f})" if raw_location.present?
  
      nil
    rescue JSON::ParserError, TypeError
      nil
    end
  
    def location_data_user
      raw_location = JSON.parse(request.headers['x-user-location'])
      geo = Geocoder.search([raw_location['x'].to_f, raw_location['y'].to_f]).first
      geo.data['display_name'] if geo.present?
    rescue JSON::ParserError, TypeError
      nil
    end
end
  