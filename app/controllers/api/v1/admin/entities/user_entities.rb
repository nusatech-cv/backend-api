module Api::V1::Admin::Entities  
  class UserEntities < Api::V1::Entities::UserEntities
    expose :id,
          documentation: {
            type: 'integer',
            desc: 'user first name'
          }
    
    expose :therapist,
        using: Api::V1::Admin::Entities::TherapistEntities,
        documentation: {
          type: Api::V1::Admin::Entities::TherapistEntities,
          desc: 'therapist data user'
        }
  
  end
end