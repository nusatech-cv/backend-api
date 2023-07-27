class Notification < ApplicationRecord
    self.inheritance_column = :type
    belongs_to :user, class_name: "User", foreign_key: :user_id, primary_key: :id
  
    def publish_to_rabbitmq
      handling_publish('notification.send_notif', as_json_event_api)
    end
  
    def as_json_event_api
      {
        id: id,
        user: user.as_json_event_api,
        title: type == 'Order' ? 'Order Messages' : 'User Messages',
        message: messages,
        is_read: is_read,
        created_at: created_at,
        updated_at: updated_at
      }
    end
  
    def notification_json_event_api
      {
        message: {
          token: user.token_device,
          notification: {
            title: type,
            body: messages
          }
        }
      }
    end
  
    def admin_notification
      {
        id: id,
        user: user.as_json_event_api,
        message: messages,
        is_read: is_read,
        created_at: created_at,
        updated_at: updated_at
      }
    end
  
    # JSON format documentation
    # {
    #   id: <integer>,
    #   user: <object> {
    #     id: <integer>,
    #     email: <string>,
    #     google_id: <string>,
    #     role: <string>,
    #     token_device: <string>
    #   },
    #   title: <string>, # 'Order Messages' or 'User Messages'
    #   message: <string>,
    #   is_read: <boolean>,
    #   created_at: <timestamp>,
    #   updated_at: <timestamp>
    # }
  end
  