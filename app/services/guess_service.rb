class GuessService
  cattr_reader :missing_category_error do ErrorService.build(
    name: 'MissingCategoryError',
    base: 'GuessError',
    message: 'Category needs to be supplied',
    code: '001'
  )
  end

  cattr_reader :duplicate_guess_term_error do ErrorService.build(
    name: 'DuplicateGuessTermError',
    base: 'GuessError',
    message: 'You have already guessed that term',
    code: '002'
  )
  end

  cattr_reader :missing_search_term_error do ErrorService.build(
    name: 'MissingSearchTermError',
    base: 'GuessError',
    message: 'Term needs to be supplied',
    code: '003'
  )
  end

  attr_reader :category_name, :term

  def initialize(category_name:, term:)
    @category_name = category_name
    @term          = term
  end

  def self.guess!(parameters)
    new(
      category_name: parameters[:category],
      term: parameters[:term]
    ).guess
  end

  def guess
    category = Category.find_by(name: category_name)
    raise @@missing_category_error unless category

    guess = Guess.new(term: term, category: category)
    guess.validate
    raise @@duplicate_guess_term_error if guess.errors.of_kind?(:term, :taken)
    raise @@missing_search_term_error if guess.errors.of_kind?(:term, :blank)

    if correct?(guess: guess, category: category)
      guess.correct = true
    end
    guess.save

    guess
  end

  def correct?(guess:, category:)
    category.answers.find_by("? = ANY(variants)", term)
  end
end
