class AuthedGuessService < GuessService

  cattr_reader :correctly_guessed_same_answer_twice do ErrorService.build(
    name: 'CorrectlyGuessedSameAnswerTwice',
    base: 'GuessError',
    message: 'You already correctly guessed that answer! Try again. This guess did not count against you.',
    code: '005',
    http_status_code: 409
  )
  end

  attr_reader :user
  def initialize(user:, **kwargs)
    @user = user
    super(**kwargs)
  end

  def guess!
    category     = set_category
    guess        = set_guess(category)
    user.guesses << guess

    return results(
      guess: guess,
      category: category,
      victory: true
    ) if all_answers_guessed?(category: category)

    search_term  = mark_correct(guess, category)
    results(guess: guess, category: category, search_term: search_term)
  end

  def mark_correct(guess, category)
    correct_answer = find_correct_answer(guess: guess, category: category)
    if correct_answer
      guess.correct = true
      user.answers  << correct_answer
      search_term   = correct_answer.term
    else
      guess.correct = false
      hint_answer   = answers_not_yet_guessed(category: category).sample
      search_term   = hint_answer.term
      # add hint
    end
    guess.save

    search_term
  end

  def set_guess(category)
    guess = Guess.new(term: term, category: category)
    guess.validate
    raise @@duplicate_guess_term_error          if guess.errors.of_kind?(:term, :taken)
    raise @@missing_search_term_error           if guess.errors.of_kind?(:term, :blank)
    raise @@correctly_guessed_same_answer_twice if answer_already_guessed(category: category, term: term)
    guess
  end

  def results(guess:, category:, search_term: nil, victory: false)
    request_results =
      if victory
        {}
      else
        CLIENT_FACTORY.build(category_name: category_name).search(search_term: search_term)
      end
    {
      guess: guess,
      results: request_results,
      wrapper: {
        guess_count: user.guesses.where(category: category).count,
        correct_count: user.correct_guesses_in_category(category).count,
        correct_remaining: answers_not_yet_guessed(category: category).count,
        correctly_guessed: user.answers.in_category(category).pluck(:term),
      },
    }
  end

  def answer_already_guessed(category:, term:)
    answers_already_guessed(category: category).find_by("? = ANY(variants) or answers.term = ?", term, term)
  end

  def answers_already_guessed(category:)
    Answer.in_category(category).where(id: user.answers.pluck(:id))
  end

  def answers_not_yet_guessed(category:)
    Answer.in_category(category).where.not(id: user.answers.pluck(:id))
  end

  def find_correct_answer(guess:, category:)
    answers_not_yet_guessed(category: category).find_by("? = ANY(variants) or answers.term = ?", term, term)
  end

  def all_answers_guessed?(category:)
    answers_not_yet_guessed(category: category).count.zero?
  end
end
