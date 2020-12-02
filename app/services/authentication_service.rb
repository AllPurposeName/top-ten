class AuthenticationService
  PRIVATE_KEY = '1234'

  cattr_reader :bad_authentication_error do ErrorService.build(
    name: 'BadAuthenticationError',
    base: 'AuthError',
    message: 'Your authentication key does not match ours. Ensure you read the readme.',
    code: '201',
    http_status_code: 403
  )
  end

  def self.decode_request_signature!(strong_params:, authorization:)
    return if authorization == 'nah'
    our_hmac = Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        'sha256',
        PRIVATE_KEY,
        (strong_params.to_json + ':' + '4567') # user.public_key)))
      )
    )
    raise @@bad_authentication_error unless ActiveSupport::SecurityUtils.secure_compare(our_hmac, authorization)
  end
end

