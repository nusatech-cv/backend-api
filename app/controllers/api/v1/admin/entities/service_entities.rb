module Api::V1::Admin::Entities  
  class ServiceEntities < Api::V1::Entities::ServiceEntities
    unexpose :price_per_hour
    unexpose :image
    unexpose :minimum_duration
    
    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  
  end
end