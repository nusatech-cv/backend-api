module SessionsHelper
    def current_user
      @user_login
    end
  
    def person_field(data)
      {
        given_name: data.names.first&.given_name,
        family_name: data.names.first&.family_name,
        email: data.email_addresses.first&.value,
        picture: data.photos.first&.url,
        id: data.metadata.sources.first&.id
      }
    end
  
    def person_oauth_field(data)
      {
        given_name: data.given_name,
        family_name: data.family_name,
        email: data.email,
        picture: data.picture,
        id: data.id
      }
    end
  
    def is_admin?
      return render_unauthorized('admin.authz.permission_denied') unless @user_login.role == 'Admin'
    end
  
    def is_therapist?
      return render_unauthorized('therapist.authz.permission_denied') unless @user_login.role == 'Therapist'
    end
  
    def is_user?
      return render_unauthorized('user.authz.permission_denied') unless @user_login.role == 'User'
    end
  
    private
  
    def render_unauthorized(message_key)
      render json: { message: message_key }, status: 401
    end
end
  