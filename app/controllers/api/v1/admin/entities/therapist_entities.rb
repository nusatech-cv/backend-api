module Api::V1::Admin::Entities
  class TherapistEntities < Api::V1::Entities::TherapistEntities
    expose :id,
          documentation: {
            type: 'integer',
            desc: 'user first name'
          }
  
    expose :first_name,
          documentation: {
            type: 'string',
            desc: 'User Therapist data'
          } do |therapist|
            therapist.user.first_name
          end
  
    expose :last_name,
          documentation: {
            type: 'string',
            desc: 'User Therapist data'
          } do |therapist|
            therapist.user.last_name
          end
  
    expose :email,
          documentation: {
            type: 'string',
            desc: 'User Therapist data'
          } do |therapist|
            therapist.user.email
          end
  
    expose :avatar,
          documentation: {
            type: 'string',
            desc: 'User Therapist data'
          } do |therapist|
            therapist.user.avatar
          end
  
    expose :role,
          documentation: {
            type: 'string',
            desc: 'User Therapist data'
          } do |therapist|
            therapist.user.role
          end
  
    expose :balances,
          documentation: {
            type: 'string',
            desc: 'average rating therapist doing services'
          } do |therapist|
            therapist.balance.nil? ? 0 : therapist.balance.balance_amount
          end
  
    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  
  end
end