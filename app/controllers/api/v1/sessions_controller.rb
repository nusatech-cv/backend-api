require 'google/apis/oauth2_v2'
require 'google/apis/people_v1'

class Api::V1::SessionsController < ApplicationController
  before_action :prepare_fetch_access_token, only: [:create]
    after_action :user_notification, only: [:create]

    def create
        if params[:access_token].present?
            signed_and_fetch_people_access_token
            raw_user_info = @clientPeople.get_person('people/me', person_fields: 'names,emailAddresses,photos,metadata')
            user_info = person_field(raw_user_info)
        else
            prepare_signet_oauth
            signed_client_and_fetch_access_token
            fetch_user = signed_and_fetch_user
            raw_user_info = fetch_user.get_userinfo
            user_info = person_oauth_field(raw_user_info)
        end

        @user = User.from_oauth(user_info)

        if User.count == 1
            @user.update(role: 'Admin')
        end

        log_activity_success(@user.id, 'Login')

        # handling_publish_event('public', 'orders', @user.google_id, @user.as_json_to_event_api)
        handling_publish_event('public', 'global', 'user', @user.as_json_to_event_api)

        return render json: {
            data: Api::V1::Entities::UserEntities.new(@user),
            token: gen_token({uid: @user.google_id, role: @user.role ,users: @user.as_token_socket_to_json})
        }, status: 201
    end

    def check_user
        access_token = params[:access_token]
        people_service = Google::Apis::PeopleV1::PeopleServiceService.new
        people_service.authorization = access_token

        profile = people_service.get_person('people/me', person_fields: 'names,emailAddresses,photos,metadata')

        return render json: profile
    end

    def callback

    end

    private
    def record_user_session
        {
            email: @user.email,
            google_id: @user.google_id,
            ip_address: request.remote_ip,
            device: request.env['HTTP_USER_AGENT'],
            login_time: Time.now,
            location: request.headers['x-user-location'].present? ? location_data_user : nil
        }
    end

    def user_notification
        handling_publish('mailer.send_email', {record: record_user_session})
        @user.notification_record(record_user_session)
    end

    def prepare_fetch_access_token
        @clientPeople = Google::Apis::PeopleV1::PeopleServiceService.new
        @oauth2Client = Google::Apis::Oauth2V2::Oauth2Service.new
    end

    def prepare_signet_oauth
        @client = Signet::OAuth2::Client.new
    end

    def signed_client_and_fetch_access_token
        @client.client_id = ENV.fetch('GOOGLE_CLIENT_ID')
        @client.client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET')
        @client.token_credential_uri = 'https://oauth2.googleapis.com/token'
        @client.redirect_uri = params[:redirect_uri]
        @client.grant_type = 'authorization_code'
        @client.code = params['code']
        @client.fetch_access_token!

        @client
    end

    def signed_and_fetch_people_access_token
        @clientPeople.authorization = params[:access_token]
        @clientPeople
    end

    def signed_and_fetch_user
        @clientPeople.authorization = @client
        @clientPeople
    end

    def signed_and_fetch_user
        @oauth2Client.authorization = @client
        @oauth2Client
    end
end
