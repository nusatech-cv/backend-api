require_relative 'base.rb'
module Api
  module V1
    module Entities
        class BalanceEntities < Base
            expose :therapist_id,
                documentation: {
                    type: 'integer',
                    desc: 'user identifier'
                }
            
            expose :balance_amount,
                documentation: {
                    type: 'decimal',
                    desc: 'amount balance of therapist'
                }
        
            with_options(format_with: :iso_timestamp) do
                expose :created_at
                expose :updated_at
            end
        end
    end
  end
end
  