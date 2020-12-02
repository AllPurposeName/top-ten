class UnauthedGuessService < GuessService

  def guess!
    category    = set_category
    guess       = set_guess(category)

    return results(
      guess: guess,
      category: category,
      victory: true
    ) if all_answers_guessed?(category: category)

    search_term = mark_correct(guess, category)
    results(guess: guess, category: category, search_term: search_term)
  end

  def set_guess(category)
    guess = Guess.new(term: term, category: category)
    guess.validate
    raise @@duplicate_guess_term_error if guess.errors.of_kind?(:term, :taken)
    raise @@missing_search_term_error  if guess.errors.of_kind?(:term, :blank)
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
        guess_count: category.guesses.count,
        correct_count: category.guesses.where(correct: true).count,
        correct_remaining: answers_not_yet_guessed(category: category).count,
        correctly_guessed: Answer.guessed_for_category(category).pluck(:term),
      },
    }
  end

  def mark_correct(guess, category)
    correct_answer = find_correct_answer(guess: guess, category: category)
    if correct_answer
      guess.correct = true
      search_term = correct_answer.term
    else
      guess.correct = false
      hint_answer   = answers_not_yet_guessed(category: category).sample
      search_term   = hint_answer.term
      # add hint
    end
    guess.save

    search_term
  end

  def answers_not_yet_guessed(category:)
    Answer.unguessed_for_category(category)
  end

  def find_correct_answer(guess:, category:)
    category.answers.find_by("? = ANY(variants) or answers.term = ?", term, term)
    # add user_answers exclusivity to prevent `the black kids` and `black kids` from both being correct
  end

  def all_answers_guessed?(category:)
    (category.answers - Answer.guessed_for_category(category)).count == 0
  end
end

