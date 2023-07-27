module Api::V1::Admin::Entities  
    class OrderDetailEntities < Api::V1::Entities::OrderEntities
        unexpose :user_id
        unexpose :therapist_id
        unexpose :service_id
    
        expose :rating,
              documentation: {
                desc: 'The rating for this order'
              } do |order|
                order.rating.present? ? order.rating.rating : nil
              end
    
        expose :user,
              using: Api::V1::Entities::UserEntities,
              documentation: {
                type: '::Entities::UserEntities',
                desc: "user data associated"
              }
    
        expose :therapist,
              using: Api::V1::Entities::TherapistEntities,
              documentation: {
                type: '::Entities::TherapistEntities',
                desc: "therapist data associated"
              }
    
        expose :service,
              using: Api::V1::Entities::ServiceEntities,
              documentation: {
                type: '::Entities::ServiceEntities',
                desc: "service data associated"
              }
    
        expose :payment,
              using: Api::V1::Entities::PaymentEntities,
              documentation: {
                type: '::Entities::PaymentEntities',
                desc: "payment data associated"
              }
    
        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end
    end
end