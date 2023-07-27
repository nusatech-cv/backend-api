require_relative 'base.rb'
module Api
  module V1
    module Entities
        class TherapistWithServiceEntities < Entities::TherapistEntities
            expose :balance,
                    documentation: {
                        type: 'string',
                        desc: 'User Therapist data'
                    } do |therapist|
                        therapist.balance.present? ? therapist.balance.balance_amount : "0.0".to_d
                    end
            expose :distance,
                    documentation: {
                        type: 'string',
                        desc: 'distance therapist from current location'
                    } do |therapist, options|
                        therapist.distance(options[:location])
                    end
        
            expose :average_rating,
                    documentation: {
                        type: 'string',
                        desc: 'User Therapist data'
                    } do |therapist|
                        therapist.count_rating.nil? ? "0.0".to_d : therapist.count_rating
                    end
        
            expose :services,
                    using: Api::V1::Entities::ServiceEntities,
                    documentation: {
                        type: 'Entities::ServiceEntities',
                        desc: 'location point'
                    } do |therapist|
                        therapist.services_therapist
                    end
            
            expose :rating,
                    using: Api::V1::Entities::RatingsServiceEntities,
                    documentation: {
                        type: 'Entities::RatingsServiceEntities',
                        desc: 'ratings of therapist'
                    } do |therapist|
                        therapist.ratings
                    end
            end
    end
  end
end
  