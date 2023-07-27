module Api::V1::Admin::Entities
    class RatingEntities < Api::V1::Entities::OrderDataEntities
      expose :user,
          using: Api::V1::Entities::UserEntities,
          documentation: {
              type: '::Entities::UserEntities',
              desc: 'User data'
          }
    
      expose :therapist,
          using: Api::V1::Entities::TherapistEntities,
          documentation: {
              type: '::Entities::TherapistEntities',
              desc: 'Therapist data'
          }
    
      expose :order_id,
          documentation: {
              type: 'integer',
              desc: 'Order data identifier'
          }
      expose :service,
          using: Api::V1::Entities::ServiceEntities,
          documentation: {
              type: '::Entities::ServiceEntities',
              desc: 'Order data'
          } do |rating|
              rating.order.service
          end
      expose :rating,
          documentation: {
              type: 'integer',
              desc: 'Order data Rating'
          }
      expose :note,
          documentation: {
              type: 'string',
              desc: 'note rating description'
          }
    end
end