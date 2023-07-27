module Api::V1::Admin::Entities  
  class TherapistServiceEntities < Api::V1::Entities::TherapistServiceEntities
    
    expose :services,
        using: Admin::Entities::ServiceEntities,
        documentation: {
            type: 'Admin::Entities:ServiceEntities',
            desc: 'Service of therapis working'
        }
  
  end
end