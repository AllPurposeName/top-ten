class User < ApplicationRecord
  has_many :guesses
  has_many :user_answers
  has_many :answers, through: :user_answers

  def correct_guesses_in_category(category)
    guesses.where(category: category, correct: true)
  end
end
