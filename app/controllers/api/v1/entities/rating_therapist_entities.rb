module Api
  module V1
    module Entities
        class RatingTherapistEntities < Entities::RatingsServiceEntities
            unexpose :user_id
            unexpose :therapist_id
            
            expose :user_avatar,
                documentation: {
                    type: 'string',
                    desc: 'User Url avatar link'
                } do |rating|
                    rating.user.avatar
                end
    
            expose :user_first_name,
                documentation: {
                    type: 'string',
                    desc: 'user firstname'
                } do |rating|
                    rating.user.first_name
                end
    
            expose :user_last_name,
                documentation: {
                    type: 'string',
                    desc: 'user firstname'
                } do |rating|
                    rating.user.last_name
                end
        end
    end
  end
end
  