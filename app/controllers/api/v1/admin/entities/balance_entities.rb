module Api::V1::Admin::Entities
    module Entities
        class BalanceEntities < Base
            expose :user,
                using: Entities::UsertEntities,
                documentation: {
                    type: 'Entities::TherapistEntities',
                    desc: 'Therapist data'
                } do |balance|
                    balance.therapist.user
                end
        end
    end
end