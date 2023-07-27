require_relative 'base.rb'
module Api
    module V1
      module Entities
        class ServiceEntities < Base
          expose :id,
                as: :service_id,
                documentation: {
                  type: 'string',
                  desc: 'location point'
                }
  
          expose :name,
                documentation: {
                  type: 'string',
                  desc: 'name service'
                }
  
          expose :description,
                documentation: {
                  type: 'string',
                  desc: 'description service'
                }
  
          expose :price_per_hour,
                documentation: {
                  type: 'string',
                  desc: 'description service'
                }
  
          expose :image,
                documentation: {
                  type: 'string',
                  desc: 'description service'
                }
  
          expose :minimum_duration,
                documentation: {
                  type: 'string',
                  desc: 'description service'
                }
        end
      end
    end
end
  