class Therapist < ApplicationRecord
    include ::GeocoderService
  
    attribute :location, :st_point, srid: 4326
  
    mount_uploader :photo, TherapistUploader
  
    has_many :therapist_services, dependent: :destroy
    has_many :orders, dependent: :destroy
    has_many :ratings, dependent: :destroy
    has_one :balance, dependent: :destroy
  
    belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id
  
    validates :experience_years, :day_start, :day_end, presence: true, numericality: { only_integer: true }
    validates :working_start, :working_end, presence: true
    validates :birthdate, :gender, presence: true
    validates :gender, presence: true
  
    validate :valid_birthdate
  
    def location_point_parsing
      {
        x: location.y,
        y: location.x
      }
    end
  
    def client_count
      Order.where(therapist_id: id).distinct.count('user_id')
    end
  
    def age
      count_age
    end
  
    def services_therapist
      Service.joins(:therapist_services).where(therapist_services: { therapist_id: id })
    end
  
    def format_time(timeat)
      time = Time.parse(timeat.to_s)
      formated_time = time.strftime("%H:%M:%S")
  
      formated_time
    end
  
    def count_rating
      Rating.where(therapist_id: id).average(:rating)
    end
  
    def as_json_to_event_api
      {
        id: id,
        user: user.as_json_to_event_api,
        is_available: is_available,
        location: location_point_parsing
      }
    end
  
    private
  
    def valid_birthdate
      begin
        Date.parse(birthdate.to_s)
      rescue ArgumentError
        errors.add(:birthdate, "format is not valid")
      end
    end
  
    def count_age
      age = date_now.year - date_therapist.year
  
      if date_now.month < date_therapist.month || (date_now.month == date_therapist.month && date_now.day < date_therapist.day)
        age -= 1
      end
  
      age
    end
  
    def date_now
      Time.zone.now.to_date
    end
  
    def date_therapist
      birthdate
    end
end
  