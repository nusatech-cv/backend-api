class Rating < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id
    belongs_to :therapist, class_name: 'Therapist', foreign_key: :therapist_id, primary_key: :id
    belongs_to :order, class_name: 'Order', foreign_key: :order_id, primary_key: :id
end
