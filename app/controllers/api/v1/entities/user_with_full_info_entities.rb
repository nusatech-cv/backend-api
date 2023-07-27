require_relative 'base.rb'
module Api
  module V1
    module Entities
        class UserWithFullInfoEntities < Entities::UserEntities
            expose :age,
                  documentation: {
                    type: 'integer',
                    desc: 'User Therapist data'
                  } do |user|
                    user.therapist.age
                  end
    
            expose :balance,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |user|
                    user.therapist.balance.present? ? user.therapist.balance.balance_amount : "0.0".to_d
                end
    
            expose :average_rating,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |user|
                    user.therapist.count_rating
                end
    
            expose :therapist,
              using: Api::V1::Entities::TherapistEntities,
              documentation: {
                type: Api::V1::Entities::TherapistEntities,
                desc: 'therapist data user'
              }
    
            expose :services,
                using: Api::V1::Entities::ServiceEntities,
                documentation: {
                    type: 'Entities::ServiceEntities',
                    desc: 'therapist services'
                } do |user|
                    user.therapist.services_therapist
                end
        
            expose :rating,
                using: ::Api::V1::Entities::RatingsServiceEntities,
                documentation: {
                    type: 'Entities::RatingsServiceEntities',
                    desc: 'ratings of therapist'
                } do |user|
                    user.therapist.ratings
                end
        end
    end
  end
end
  