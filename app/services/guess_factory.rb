class GuessFactory
  def self.guess!(category:, term:, user:)
    if user
      AuthedGuessService.new(category_name: category, term: term, user: user).guess!
    else
      UnauthedGuessService.new(category_name: category, term: term).guess!
    end
  end
end
