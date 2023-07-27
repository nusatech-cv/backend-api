class Service < ApplicationRecord
    HOURS = 59
    mount_uploader :image, ServicesUploader
  
    has_many :therapist_services, dependent: :destroy
    has_many :orders, dependent: :destroy
  
    # validates :name, :description, :image, presence: true
    # validates :price_per_hour, numericality: { greater_than: 0 }
    # validates :minimum_duration, numericality: { greater_than: 0 }
  
    def count_price_service(duration)
      time_duration = duration.to_f / HOURS.to_f
      price = price_per_hour / time_duration
      price
    end
end
  