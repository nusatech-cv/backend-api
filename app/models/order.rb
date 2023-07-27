class Order < ApplicationRecord
    include AASM
  
    attribute :location, :st_point, srid: 4326
  
    belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id
    belongs_to :therapist, class_name: 'Therapist', foreign_key: :therapist_id, primary_key: :id
    belongs_to :service, class_name: 'Service', foreign_key: :service_id, primary_key: :id
  
    UPDATED_ORDER = ['paid', 'start', 'expire', 'done', 'cancel']
    THERAPIST_UPDATE = ['waiting_payment', 'appointment_start', 'done', 'cancel']
    USER_UPDATE = ['paid', 'cancel']
  
    has_one :payment, dependent: :destroy
    has_one :rating, dependent: :destroy
  
    before_create :assign_uid_generated, :assignment_price, :validate_user_orders, :validate_therapist_orders, :validate_appointment_time
    validates :appointment_date, :therapist_id, :service_id, :user_id, presence: true

    after_commit on: :create do
      distance = ::GeocoderService::Geocoder.new.distance_with_single_points({x: therapist.location.y, y: therapist.location.x}, location_point_parsing)
      configuration
      publish_events_to_rabbitmq
      send_rabbitmq_message("Anda mendapatkan orderan baru dari #{user.first_name} dengan jarak dari lokasi #{distance} Km", therapist.user, 'created')
    end
  
    after_commit on: :update do
      case order_status
      when 'waiting_payment'
        send_rabbitmq_message("Order anda telah dikonfirmasi oleh therapist yang anda pesan, silahkan lakukan pembayaran untuk melanjutkan ke proses selanjutnya", user, 'confirmation')
      when 'paid'
        send_rabbitmq_message("Order untuk service anda telah dibayar silahkan melaksanakan service kepada customer sesuai dengan lokasi dan waktu pemesanan", therapist.user, 'paid')
      when 'cancel'
        send_rabbitmq_message("Maaf, pesanan anda telah dibatalkan, silahkan mengorder kembali pada waktu yang lain", user, 'cancel')
      when 'appointment_start'
        update_therapist_availability(false)
      when 'expired'
        send_rabbitmq_message("Maaf, sayang sekali order layanan anda telah expired, silahkan lakukan order layanan kembali", user, 'expired')
      when 'done'
        update_therapist_availability(true)
        send_rabbitmq_message("Terimakasih layanan anda telah selesai silahkan berikan rating dan pengalaman tentang service yang anda terima", user, 'done')
      end
    end
  
    aasm column: 'order_status', whiny_transitions: false do
      state :waiting_confirmation, initial: true
      state :waiting_payment
      state :paid
      state :appointment_start
      state :done
      state :cancel
      state :expired
  
      event :waiting_payment do
        transitions from: :waiting_confirmation, to: :waiting_payment
      end
  
      event :paid do
        transitions from: :waiting_payment, to: :paid
      end
  
      event :expire do
        transitions from: %i[waiting_confirmation waiting_payment], to: :expired
      end
  
      event :appointment_start do
        transitions from: :paid, to: :appointment_start
      end
  
      event :done do
        transitions from: %i[waiting_confirmation waiting_payment], to: :done
      end
  
      event :cancel do
        transitions from: %i[waiting_confirmation waiting_payment], to: :canceled
      end
    end
  
    def location_point_parsing
      {
        x: location.y,
        y: location.x
      }
    end
  
    def assignment_price
      price = service.count_price_service(appointment_duration)
      self.total_price = price
    end
  
    def assign_uid_generated
      self.uid = generate_uid('O')
    end
  
    def as_json_to_event_api
      {
        id: id,
        uid: uid,
        user: user.as_token_jwt_to_json,
        therapist: therapist.user.as_token_jwt_to_json,
        service_id: service.id,
        order_status: order_status,
        appointment_date: appointment_date,
        appointment_duration: appointment_duration,
        total_price: total_price,
        location: location_point_parsing,
        note: note,
        created_at: created_at,
        updated_at: updated_at
      }
    end
  
    def as_json_to_email_api
      {
        id: id,
        order_status: order_status,
        appointment_date: appointment_date,
        appointment_duration: appointment_duration,
        total_price: total_price,
        location: location_point_parsing,
        note: note,
        created_at: created_at,
        updated_at: updated_at
      }
    end
  
    private
  
    def send_rabbitmq_message(message, recipient, event)
      data = as_json_to_email_api.merge({ email: recipient.email, google_id: recipient.google_id })
  
      configuration
      # publish_mail_event('mailer.send_email', data)
      # publish_events_to_rabbitmq(event)
      Notification.create(build_notification_message(message, recipient))
    end
  
    def publish_events_to_rabbitmq(event = nil)
      handling_publish_event('private', therapist.user.google_id, 'orders', { record: as_json_to_event_api })
      handling_publish_event('private', user.google_id, 'orders', { record: as_json_to_event_api })
      handling_publish_event('public', 'global', 'orders', { record: as_json_to_event_api })
      publish_to_user
      publish_to_therapist
    end
  
    def publish_to_user
      handling_publish_event('private', user.google_id, uid, { record: as_json_to_event_api })
    end
  
    def publish_to_therapist
      handling_publish_event('private', therapist.user.google_id, uid, { record: as_json_to_event_api })
    end
  
    def build_notification_message(message, recipient)
      {
        user_id: recipient.id,
        messages: message,
        tipe: 'Order',
        reference_id: id,
        reference_type: "Order"
      }
    end
  
    def update_therapist_availability(status)
      therapist.update(is_available: status)
    end
  
    def generate_uid(prefix)
      loop do
        uid = "%s%s" % [prefix.upcase, SecureRandom.hex(7).upcase]
        return uid if Order.where(uid: uid).empty?
      end
    end

    def validate_user_orders
      existing_user_orders = user.orders.where(order_status: ['waiting_payment', 'appointment_start','waiting_confirmation'])
      if existing_user_orders.exists?
        errors.add(:base, "You cannot create a new order while you have existing orders")
        throw(:abort)
      end
    end

    def validate_therapist_orders
      existing_therapist_orders = therapist.orders.where(order_status: ['waiting_payment', 'appointment_start', 'waiting_confirmation'])
      if existing_therapist_orders.exists?
        errors.add(:base, "You cannot create a new order while your therapist has existing orders")
        throw(:abort)
      end
    end

    def validate_appointment_time
      start_time = appointment_date.to_datetime
      if start_time < (Time.now + 1.hour)
        errors.add(:appointment_date, "should be at least 1 hour from now")
        throw(:abort)
      end
    end

end
  