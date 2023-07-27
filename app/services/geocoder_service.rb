# frozen_string_literal: true

module GeocoderService
    class Geocoder
      EARTH_RADIUS = 6371.0
  
      def distance_with_multiple_points(base_location, target_location)
        data = []
        target_location.each do |data|
          distance = haversine_formula(base_location, data.location)
          data.push(data.id) if distance <= 5
        end
        data
      end
  
      def distance_with_single_points(base_location, target_location)
        haversine_formula(base_location, target_location)
      end
  
      private
  
      def haversine_formula(base_location, target_location)
        lat1_rad, lon1_rad, lat2_rad, lon2_rad = convert_degree_to_radians(base_location[:x], base_location[:y], target_location[:x], target_location[:y])
  
        d_lat = lat2_rad - lat1_rad
        d_lon = lon2_rad - lon1_rad
  
        a = Math.sin(d_lat / 2) * Math.sin(d_lat / 2) +
            Math.cos(lat1_rad) * Math.cos(lat2_rad) *
            Math.sin(d_lon / 2) * Math.sin(d_lon / 2)
  
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
        distance = EARTH_RADIUS * c
  
        distance
      end
  
      def convert_degree_to_radians(lat1, lon1, lat2, lon2)
        lat1_rad, lon1_rad, lat2_rad, lon2_rad = deg2rad(lat1), deg2rad(lon1), deg2rad(lat2), deg2rad(lon2)
        [lat1_rad, lon1_rad, lat2_rad, lon2_rad]
      end
  
      def deg2rad(deg)
        deg * (Math::PI / 180)
      end
    end
end
  