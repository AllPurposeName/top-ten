class Answer < ApplicationRecord
  belongs_to :category

  validates :term, presence: true, uniqueness: { scope: :category }

  after_initialize :set_ranking, if: :new_record?

  def set_ranking
    self.ranking ||= (self.class.in_category(category).maximum(:ranking) || 0) + 1
  end

  scope :in_category, -> (category = nil) { where(category: category) if category }
  scope :unguessed_for_cateogry, -> (category = nil) do
    answers = arel_table
    where(category: category)
      .where(
        answers[:term].not_in(
          Guess.where(category: category).pluck(:term)
        )
      )
  end
  scope :guessed_for_category, -> (category = nil) do
    answers = arel_table
    where(category: category)
      .where(
        answers[:term].in(
          Guess.where(category: category).pluck(:term)
        )
      )
  end
end
