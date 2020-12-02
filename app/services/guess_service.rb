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

  cattr_reader :category_not_supported_error do ErrorService.build(
    name: 'CategoryNotSupportedError',
    base: 'GuessError',
    message: "We do not support that category. Try one of #{ClientFactory.categories}",
    code: '004'
  )
  end

  attr_reader :category_name, :term

  def initialize(category_name:, term:)
    @category_name = category_name
    @term          = term&.downcase&.chomp
  end

  def self.guess!(parameters)
    new(
      category_name: parameters[:category],
      term:          parameters[:term]
    ).guess!
  end

  def guess!
    category = Category.find_by(name: category_name)
    raise @@missing_category_error       unless category
    raise @@category_not_supported_error unless ClientFactory.categories.include?(category_name)

    guess = Guess.new(term: term, category: category)
    guess.validate
    raise @@duplicate_guess_term_error if guess.errors.of_kind?(:term, :taken)
    raise @@missing_search_term_error  if guess.errors.of_kind?(:term, :blank)

    return victory(guess, category) if all_answers_guessed?(category: category)
    correct_answer = correct?(guess: guess, category: category)
    if correct_answer
      guess.correct = true
      search_term = correct_answer.term
    else
      guess.correct = false
      hint_answer = Answer.unguessed_for_cateogry(category).sample
      search_term = hint_answer.term
    end
    guess.save

    results(guess, category, search_term)
    {
      guess: guess,
      wrapper: {
        guess_count: category.guesses.count,
        correct_count: category.guesses.where(correct: true).count,
        correct_remaining: category.answers.count - category.guesses.where(correct: true).count,
        correctly_guessed: Answer.guessed_for_category(category).pluck(:term),
      },
    }
  end

  def correct?(guess:, category:)
    category.answers.find_by("? = ANY(variants) or answers.term = ?", term, term)
    # add user_answers exclusivity to prevent `the black kids` and `black kids` from both being correct
  end

  def results(guess:, category:, search_term: nil, victory: false)
    request_results =
      if victory
        {}
      else
        ClientFactory.build(category_name: category_name).search(search_term: search_term)
      end
    {
      guess: guess,
      results: {request_results,
      wrapper: {
        guess_count: category.guesses.count,
        correct_count: category.guesses.where(correct: true).count,
        correct_remaining: category.answers.count - category.guesses.where(correct: true).count,
        correctly_guessed: Answer.guessed_for_category(category).pluck(:term),
      },
    }
  end

  def all_answers_guessed?(category:)
    category.answers.count - category.guesses.where(correct: true).count <= 0
  end
end
