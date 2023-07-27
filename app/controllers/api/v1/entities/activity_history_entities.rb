require_relative 'base.rb'
module Api
  module V1
    module Entities
      class ActivityHistoryEntities < Base
        expose :first_name,
              documentation: {
                type: 'string',
                desc: 'User Therapist data'
              } do |activity|
                activity.user.first_name
              end

        expose :last_name,
              documentation: {
                type: 'string',
                desc: 'User Therapist data'
              } do |activity|
                activity.user.last_name
              end

        expose :user_email,
              documentation: {
                type: 'string',
                desc: 'User Therapist data'
              } do |activity|
                activity.user.email
              end

        expose :result,
              documentation: {
                type: 'string',
                desc: 'User Therapist result data'
              }

        expose :activity_type,
            documentation: {
                type: 'string',
                desc: 'action point'
            }

        expose :ip_address,
            documentation: {
                type: 'string',
                desc: 'ip_address point'
            }

        expose :device_info,
            documentation: {
                type: 'string',
                desc: 'location point'
            }

        expose :device_info,
            documentation: {
                type: 'string',
                desc: 'location point'
            }


        expose :location,
            documentation: {
                type: 'string',
                desc: 'location point'
            } do |activity|
              activity.parsing_location
            end

        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end
      end
    end
  end
end
  