class UserService

  cattr_reader :user_name_not_provided_error do ErrorService.build(
    name: 'UserNameNotProvidedError',
    base: 'AuthError',
    message: 'No user name provided. Ensure you read the readme!',
    code: '203',
    http_status_code: 422
  )
  end

  cattr_reader :user_name_not_unique_error do ErrorService.build(
    name: 'UserNameNotUniqueError',
    base: 'AuthError',
    message: 'This username has already been taken',
    code: '204',
    http_status_code: 422
  )
  end

  def self.create!(name:)
    raise @@user_name_not_provided_error unless name
    user = User.new(name: name)
    user.public_key = SecureRandom.hex
    user.private_key = SecureRandom.hex
    user.validate
    raise @@user_name_not_unique_error if user.errors.of_kind?(:name, :uniqueness)
    user.save
    user
  end
end
