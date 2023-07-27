require_relative 'base.rb'
module Api
  module V1
    module Entities
        class OrderEntities < Base
            expose :id,
                documentation: {
                    type: 'integer',
                    desc: 'unique identifier'
                }
            expose :uid,
                documentation: {
                    type: 'string',
                    desc: 'User Unique identifier'
                }
    
            expose :user_id,
                documentation: {
                    type: 'integer',
                    desc: 'user unque identifier'
                }
            expose :therapist_id,
                documentation: {
                    type: 'integer',
                    desc: 'therapist identifier'
                }
            expose :service_id,
                documentation: {
                    type: 'integer',
                    desc: 'service identifier'
                }
            expose :order_status,
                documentation: {
                    type: 'string',
                    desc: 'status order service with therapist'
                }
            expose :appointment_start_at,
                as: :appointment_start,
                documentation: {
                    type: 'timestamp',
                    desc: 'appointment date expectation'
                }
    
            expose :appointment_end,
                as: :appointment_end,
                documentation: {
                    type: 'timestamp',
                    desc: 'appointment date expectation'
                }
            expose :appointment_date,
                documentation: {
                    type: 'timestamp',
                    desc: 'appointment date expectation'
                }
            expose :appointment_duration,
                documentation: {
                    type: 'timestamp',
                    desc: 'appointment duration expectation'
                }
            expose :total_price,
                documentation: {
                    type: 'decimal',
                    desc: 'total price of service order'
                }
                
            expose :location,
                documentation: {
                    desc: 'location point coordinates'
                } do |order|
                    order.location_point_parsing
                end
    
            expose :note,
                documentation: {
                    type: 'string',
                    desc: 'location point coordinates'
                }
    
            with_options(format_with: :iso_timestamp) do
              expose :created_at
              expose :updated_at
            end
        end
    end
  end
end
  