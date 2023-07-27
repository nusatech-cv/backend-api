class ActivityHistory < ApplicationRecord
    attribute :location, :st_point, srid: 4326
  
    belongs_to :user, class_name: "User", foreign_key: :user_id, primary_key: :id
  
    def parsing_location
      if location.nil?
        { x: nil, y: nil }
      else
        { x: location.y, y: location.x }
      end
    end
end
  