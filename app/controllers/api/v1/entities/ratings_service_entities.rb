require_relative 'base.rb'
module Api
  module V1
    module Entities
        class RatingsServiceEntities < Base
            expose :user_id,
                    documentation: {
                        type: 'integer',
                        desc: 'user identifier'
                    }
    
            expose :therapist_id,
                    documentation: {
                        type: 'integer',
                        desc: 'user identifier'
                    }
                    
            expose :order_id,
                    documentation: {
                        type: 'integer',
                        desc: 'user identifier'
                    }
    
            expose :rating,
                    documentation: {
                        type: 'string',
                        desc: 'rating order'
                    }
    
            expose :note,
                    documentation: {
                        type: 'string',
                        desc: 'rating order'
                    }
    
            with_options(format_with: :iso_timestamp) do
              expose :created_at
              expose :updated_at
            end
        end
    end
  end
end
  