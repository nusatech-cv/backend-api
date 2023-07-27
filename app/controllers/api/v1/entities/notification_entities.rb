require_relative 'base.rb'
module Api
  module V1
    module Entities
        class NotificationEntities < Base
            expose :id,
                    as: :notif_id,
                    documentation: {
                        type: 'integer',
                        desc: 'the notificaion id of the notification'
                    }
            expose :messages,
                    documentation: {
                        type: 'string',
                        desc: 'message notification to firebase'
                    }
    
            expose :is_send,
                    documentation: {
                        type: 'boolean',
                        desc: 'status message is notification has been send'
                    }
                
            expose :is_read,
                    documentation: {
                        type: 'boolean',
                        desc: 'status message is notification has been read'
                    }
            expose :created_at,
                    documentation: {
                        type: 'timestamp',
                        desc: 'time of notification'
                    }
        end
    end
  end
end
  