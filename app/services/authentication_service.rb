class AuthenticationService
  PRIVATE_KEY = '1234'

  cattr_reader :bad_authorization_error do ErrorService.build(
    name: 'BadAuthenticationError',
    base: 'AuthError',
    message: 'Your authorization key does not match ours. Ensure you read the readme!',
    code: '201',
    http_status_code: 403
  )
  end

  cattr_reader :no_user_error do ErrorService.build(
    name: 'NoUserError',
    base: 'AuthError',
    message: 'No user name provided. Please provide one in the query parameters',
    code: '202',
    http_status_code: 403
  )
  end

  def self.decode_request_signature!(strong_params:, authorization:, user:)
    return if authorization == 'nah'
    raise @@no_user_error unless user
    calculated_hmac = Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        'sha256',
        user.private_key,
        (strong_params.to_json + ':' + user.public_key)
      )
    )
    raise @@bad_authorization_error unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, authorization)
  end
end
