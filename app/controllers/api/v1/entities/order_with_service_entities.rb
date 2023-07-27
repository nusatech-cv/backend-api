require_relative 'base.rb'
module Api
  module V1
    module Entities
        class OrderWithServiceEntities < Entities::OrderEntities
            expose :user_id,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |order|
                    order.user.id
                end
    
            expose :user_email,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |order|
                    order.user.email
                end
    
            expose :user_last_name,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |order|
                    order.user.last_name
                end
            
            expose :user_avatar,
                documentation: {
                    type: 'string',
                    desc: 'User avatar data'
                } do |order|
                    order.user.avatar
                end
    
            expose :therapist_name,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |order|
                    "#{order.therapist.user.first_name} #{order.therapist.user.last_name}"
                end
    
            expose :therapist_avatar,
                documentation: {
                    desc: 'Therapist avatar'
                } do |order|
                    order.therapist.photo
                end
    
            expose :distance,
                documentation: {
                    type: 'distance of order',
                    desc: 'The distance of order'
                }
                
            expose :service_name,
                documentation: {
                    type: 'service user and therapist order',
                    desc: 'service_name description'
                } do |order|
                    order.service.name
                end
            
            expose :service_description,
                documentation: {
                    type: 'service user and therapist order',
                    desc: 'service_name description'
                } do |order|
                    order.service.description
                end
        
            expose :ratings,
                using: Entities::RatingsServiceEntities,
                documentation: {
                    type: 'Entities::RatingsServiceEntities',
                    desc: 'ratings description for order'
                } do |order|
                    order.rating
                end
        end
    end
  end
end
  