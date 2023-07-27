require_relative 'base.rb'
module Api
  module V1
    module Entities
        class TherapistPaymentEntities < Entities::PaymentEntities
            expose :order_id,
                documentation: {
                  type: 'integer',
                  desc: 'identifier for order'
                }
            expose :user_id,
                documentation: {
                  type: 'integer',
                  desc: 'identifier for order'
                }
            expose :service_name,
                documentation: {
                  type: 'string',
                  desc: 'service name for order'
                } do |payment|
                  payment.order.service.name
                end
            expose :appointment_duration,
                documentation: {
                  type: 'integer',
                  desc: 'time duration'
                } do |payment|
                  payment.order.appointment_duration
                end
            expose :user_first_name,
                documentation: {
                  type: 'string',
                  desc: 'user first name data'
                } do |payment|
                  payment.user.first_name
                end
            expose :user_last_name,
                documentation: {
                  type: 'string',
                  desc: 'user last name data'
                } do |payment|
                  payment.user.last_name
                end
            end
    end
  end
end
  