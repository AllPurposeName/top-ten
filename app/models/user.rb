class User < ApplicationRecord
  has_many :user_answers
  has_many :answers, through: :user_answers
end
