class Guess < ApplicationRecord
  belongs_to :category

  validates :term, presence: true, uniqueness: { scope: [:category, :user_id] }

  scope :in_category, -> (category = nil) { where(category: category) if category }
end
