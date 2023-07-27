module Api::V1::Admin::Entities
    class PaymentEntities < Api::V1::Entities::PaymentEntities        
      expose :user,
          using: Api::V1::Entities::UserEntities,
          documentation: {
              type: '::Entities::UserEntities',
              desc: 'user data payment'
          }
    
      expose :therapist,
          using: Api::V1::Entities::TherapistEntities,
          documentation: {
              type: '::Entities::TherapistEntities',
              desc: 'user data payment'
          } do |payment|
              payment.order.therapist
          end
    
      expose :service,
          using: Api::V1::Entities::ServiceEntities,
          documentation: {
              type: '::Entities::ServiceEntities',
              desc: 'data service order'
          } do |payment|
              payment.order.service
          end
    end
end