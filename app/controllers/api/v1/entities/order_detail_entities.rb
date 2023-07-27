require_relative 'base.rb'
module Api
  module V1
    module Entities
        class OrderDetailEntities < Entities::OrderWithServiceEntities
            expose :payment,
                using: Entities::PaymentEntities,
                documentation: {
                    type: Entities::PaymentEntities,
                    desc: 'Payment order'
                } do |order|
                    order.payment
                end
    
        end
    end
  end
end
  