class Payment < ApplicationRecord
    PAYMENT_LIST = ['Ovo', 'Dana', 'Bidr']
  
    belongs_to :order, class_name: "Order", foreign_key: :order_id, primary_key: :id
    belongs_to :user, class_name: "User", foreign_key: :user_id, primary_key: :id
  
    after_commit on: :create do
      update_balance_therapist
    end
  
    def update_balance_therapist
      balance = Balance.find_or_create_by(therapist_id: order.therapist_id)
      balance.update(balance_amount: balance.balance_amount + amount_paid)
    end   
  
    def as_json_for_event_api
      {
        id: id,
        order_id: order_id,
        user: user.as_json_to_event_api,
        payment_method: payment_method,
        payment_status: payment_status,
        amount_paid: amount_paid,
        to_account: to_account,
        sender_account: sender_account,
        payment_expired: payment_expired,
        payment_at: payment_at,
        updated_at: updated_at
      }
    end
  
    def as_json_for_email_api(location)
      {
        email: user.email,
        google_id: user.google_id,
        location: location,
        payment_method: payment_method,
        payment_status: payment_status,
        amount_paid: amount_paid,
        to_account: to_account,
        sender_account: sender_account,
        payment_expired: payment_expired,
        payment_at: payment_at
      }
    end
  
    def publish_data(location)
      handling_publish('mailer.send_email', as_json_for_email_api(location))
    end
end
  