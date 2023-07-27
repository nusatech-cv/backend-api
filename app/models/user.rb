class User < ApplicationRecord
    include Encryptable
  
    attr_encrypted :first_name, :last_name
  
    has_one :therapist
    has_many :ratings
    has_many :payments
    has_many :orders
    has_many :activity_histories
    has_many :notifications, dependent: :destroy
  
    class << self
      def from_oauth(access_token)
        params = filter_payload(access_token)
        user = User.find_or_create_by(email: access_token[:email], google_id: access_token[:id]) do |m|
          m.email = params[:email]
          m.first_name = params[:first_name]
          m.last_name = params[:last_name]
          m.google_id = params[:google_id]
          m.avatar = params[:avatar]
        end
        user.save!
  
        user
      end
  
      def filter_payload(payload)
        {
          email: payload[:email],
          first_name: payload[:given_name],
          last_name: payload[:family_name],
          google_id: payload[:id],
          avatar: payload[:picture]
        }
      end
    end
  
    def user_admin
      User.find_by(role: 'Admin')
    end
  
    def notification_record(params)
      notifications.create({
        tipe: 'Login',
        messages: "New Login Detected, with data #{params[:ip_address]} at #{params[:device]}",
        reference_id: id,
        reference_type: 'Users'
      })
    end
  
    def as_json_to_event_api
      {
        id: id,
        email: email,
        google_id: google_id.to_s,
        uid: google_id.to_s,
        role: role,
        token_device: token_device
      }
    end
  
    def as_token_jwt_to_json
      {
        id: id,
        first_name: first_name,
        last_name: last_name,
        email: email,
        role: role
      }
    end
  
    def as_token_socket_to_json
      {
        uid: google_id,
        email: email,
        role: role
      }
    end
  
    # {
    #     id: 1,
    #     email: 'foo@example.com',
    #     google_id: '111721302605996425373',
    #     role: 'Admin',
    #     token_device: 'eRLSCHs9QDyBdh8d7y7svs:APA91bGoqcFTyDA7WPR3R2gSUXQpaCZpPGR17zoEABaZ0YyB_gJ3sowDgk9eYTxEwdF4kZszMaWloIaS75sCstrpPc_DYVkgQMY0cOuwdqlxQKc_1TCfZMZrAfhqAtHJ4uTABaUexxn1'
    # }
 end
  