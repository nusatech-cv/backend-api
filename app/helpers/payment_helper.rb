module PaymentHelper
    def validate_payment
      Payment::PAYMENT_LIST.include?(params[:payment_method])
    end
  
    def payment_params(order)
      {
        user_id: current_user.id,
        order_id: params[:id],
        payment_method: params[:payment_method],
        amount_paid: order.total_price,
        to_account: to_account_value,
        sender_account: current_user.email,
        payment_expired: Time.now + 1.hour,
        payment_at: Time.now + 1.hour,
        payment_status: 'success'
      }
    end
  
    private
  
    def generate_address
      SecureRandom.base64(20)
    end
  
    def to_account_value
      if params[:payment_method] == 'bidr'
        generate_address
      else
        params[:account_number]
      end
    end
  
    def send_message_to_rabbitmq(message, prefix, event)
      data = as_json_to_email_api.merge({ email: prefix.email, google_id: prefix.google_id })
  
      configuration
      handling_publish('mailer.send_email', data)
      Notification.create(build_message(message, user))
    end
  
    def build_message(message, user)
      {
        user_id: user.id,
        messages: message,
        tipe: 'Orders',
        reference_id: id,
        reference_type: "Order"
      }
    end
  end
  