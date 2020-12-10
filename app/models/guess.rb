class Guess < ApplicationRecord
  belongs_to :category

  validates :term, presence: true, uniqueness: { scope: :category }
end
