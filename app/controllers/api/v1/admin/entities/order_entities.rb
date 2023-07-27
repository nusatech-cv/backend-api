module Api::V1::Admin::Entities
  class OrderEntities < Api::V1::Entities::OrderEntities
    expose :id,
        documentation: {
          type: 'integer',
          desc: 'user first name'
        }
  end
end