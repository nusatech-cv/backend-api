require_relative 'base.rb'
module Api
  module V1
    module Entities
        class TherapistWithFullInfoEntities < Entities::TherapistEntities
            expose :client_total,
                  documentation: {
                    type: 'integer',
                    desc: 'The therapist client total'
                  } do |therapist|
                    therapist.client_count
                  end
    
            expose :review_total,
                  documentation: {
                    type: 'integer',
                    desc: 'The Therapist review total'
                  } do |therapist|
                    therapist.ratings.count
                  end
    
            expose :first_name,
                  documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                  } do |therapist|
                    therapist.user.first_name
                  end
    
            expose :last_name,
                  documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                  } do |therapist|
                    therapist.user.last_name
                  end
                
            expose :age,
                  documentation: {
                    type: 'integer',
                    desc: 'User Therapist data'
                  } do |therapist|
                    therapist.age
                  end
                
            expose :distance,
                documentation: {
                    type: 'string',
                    desc: 'distance therapist from current location'
                }
    
            expose :services,
                using: Entities::ServiceEntities,
                documentation: {
                    type: 'Entities::ServiceEntities',
                    desc: 'therapist services'
                } do |therapist|
                    therapist.services_therapist
                end
        
            expose :ratings,
                using: Entities::RatingTherapistEntities,
                documentation: {
                    type: 'Entities::RatingTherapistEntities',
                    desc: 'ratings of therapist'
                }
            
            with_options(format_with: :iso_timestamp) do
                expose :created_at
                expose :updated_at
            end
        end
    end
  end
end
  