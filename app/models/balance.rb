class Balance < ApplicationRecord
    belongs_to :therapist, class_name: "Therapist", foreign_key: :therapist_id, primary_key: :id
end
