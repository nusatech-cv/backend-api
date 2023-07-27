require_relative 'base.rb'

module Api
    module V1
      module Entities
        class UserEntities < Base
          expose :first_name,
            documentation: {
              type: 'string',
              desc: 'User first name'
            }
          expose :last_name,
            documentation: {
              type: 'string',
              desc: 'User last name'
            }
          expose :email,
            documentation: {
              type: 'string',
              desc: 'User email address'
            }
          expose :google_id,
            documentation: {
              type: 'string',
              desc: 'User Google ID'
            }
          expose :avatar,
            documentation: {
              type: 'string',
              desc: 'Avatar user data'
            }
  
          expose :role,
            documentation: {
              type: 'string',
              desc: 'Role user data'
            }
  
          expose :token_device,
            documentation: {
              type: 'string',
              desc: 'Token device user data'
            }
  
          with_options(format_with: :iso_timestamp) do
            expose :created_at,
              documentation: {
                type: 'string',
                desc: 'User created date in ISO 8601 format'
              }
            expose :updated_at,
              documentation: {
                type: 'string',
                desc: 'User updated date in ISO 8601 format'
              }
          end
        end
      end
    end
end
  