require 'openssl'

module JwtHelper
  def encode_token(payload)
    JWT.encode(merge_payload(payload), private_key, 'RS256')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split(' ').last
    begin
      JWT.decode(token, public_key, true, algorithm: 'RS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def authorized
    render json: { message: 'JWT Signature invalid or JWT has expired' }, status: :unauthorized unless logged_in?
  end

  def gen_token(resource)
    encode_token(merge_payload(resource))
  end

  private

  def logged_in_user
    return unless decoded_token

    user_email = decoded_token[0]['users']['email']
    @user_login ||= User.find_by(email: user_email)
  end

  def no_expired?
    decoded_token[0]['exp'] >= Time.now.to_i
  end

  def logged_in?
    !!logged_in_user
  end

  def private_key
    OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV.fetch('JWT_PRIVATE_KEY')))
  rescue OpenSSL::PKey::RSAError
    nil
  end

  def public_key
    OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV.fetch('JWT_PUBLIC_KEY')))
  rescue OpenSSL::PKey::RSAError
    nil
  end

  def merge_payload(resource)
    resource.reverse_merge(
      sub: 'session',
      aud: 'backend',
      iss: 'beautycare',
      iat: Time.now.to_i,
      exp: (Time.now + 10.hours).to_i,
      jti: SecureRandom.hex(10)
    )
  end
end
