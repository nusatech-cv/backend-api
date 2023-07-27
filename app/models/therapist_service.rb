class TherapistService < ApplicationRecord
    belongs_to :therapist, class_name: "Therapist", foreign_key: :therapist_id, primary_key: :id
    belongs_to :service, class_name: "Service", foreign_key: :service_id, primary_key: :id
end