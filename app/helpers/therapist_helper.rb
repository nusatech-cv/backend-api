module TherapistHelper
    def therapist_params
      {
        user_id: current_user.id,
        location: parsing_location_therapist,
        experience_years: params[:experience_years],
        photo: params[:photo],
        day_start: params[:day_start],
        day_end: params[:day_end],
        working_start: params[:working_start],
        working_end: params[:working_end],
        birthdate: params[:birthdate],
        gender: params[:gender],
        is_available: params[:is_available]
      }
    end
  
    def rating_query
      Arel.sql("AVG(ratings.rating)")
    end
  
    def query_arel_distance
      Arel.sql("ST_Distance(location, ST_GeomFromText('#{parsing_header_location}', 4326)) / 1000")
    end
  
    def query_arel_order
      Arel.sql("location <-> ST_GeomFromText('#{parsing_header_location}', 4326)")
    end
  
    def build_query_params
      ''
    end
  
    def parsing_location_therapist
      params_location = JSON.parse(params[:location])
      x, y = params_location['x'].to_f, params_location['y'].to_f
 
      "POINT(#{y} #{x})"
    end
  end
  