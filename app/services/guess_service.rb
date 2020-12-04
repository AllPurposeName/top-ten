class GuessService
  CLIENT_FACTORY = ClientFactory.new
  cattr_reader :missing_category_error do ErrorService.build(
    name: 'MissingCategoryError',
    base: 'GuessError',
    message: 'Category needs to be supplied',
    code: '001',
    http_status_code: 422
  )
  end

  cattr_reader :duplicate_guess_term_error do ErrorService.build(
    name: 'DuplicateGuessTermError',
    base: 'GuessError',
    message: 'You have already guessed that term',
    code: '002',
    http_status_code: 409
  )
  end

  cattr_reader :missing_search_term_error do ErrorService.build(
    name: 'MissingSearchTermError',
    base: 'GuessError',
    message: 'Term needs to be supplied',
    code: '003',
    http_status_code: 422
  )
  end

  cattr_reader :category_not_supported_error do ErrorService.build(
    name: 'CategoryNotSupportedError',
    base: 'GuessError',
    message: "We do not support that category. Try one of #{CLIENT_FACTORY.categories}",
    code: '004',
    http_status_code: 422
  )
  end

  attr_reader :category_name, :term

  def initialize(category_name:, term:)
    @category_name = category_name
    @term          = term&.downcase&.chomp
  end

  def self.guess!(category:, term:, user:)
    guesser = new(
      category_name: :category,
      term:          :term,
      user:          :user
    )
    if user
      authenticated_guess
    else
      unauthenticated_guess
    end
  end

  def set_category
    category = Category.find_by(name: category_name)
    raise @@missing_category_error       unless category
    raise @@category_not_supported_error unless CLIENT_FACTORY.categories.include?(category_name)
    category
  end
end
