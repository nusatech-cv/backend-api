require_relative 'base.rb'
module Api
  module V1
    module Entities
        class PaymentEntities < Base
            expose :payment_method,
                documentation: {
                    type: 'string',
                    desc: 'payment method order'
                }
    
            expose :payment_status,
                documentation: {
                    type: 'string',
                    desc: 'payment status order'
                }
    
            expose :amount_paid,
                documentation: {
                    type: 'decimal',
                    desc: 'amount payment order'
                }
    
            expose :to_account,
                documentation: {
                    type: 'string',
                    desc: 'to account payment order'
                }
    
            expose :sender_account,
                documentation: {
                    type: 'string',
                    desc: 'sender account payment order'
                }
    
            expose :payment_expired,
                documentation: {
                    type: 'timestamp',
                    desc: 'payment expiration date'
                }
    
            expose :payment_at,
                documentation: {
                    type: 'timestamp',
                    desc: 'success payer payment to account'
                }
    
    
            with_options(format_with: :iso_timestamp) do
              expose :created_at
              expose :updated_at
            end
        end
    end
  end
end
  