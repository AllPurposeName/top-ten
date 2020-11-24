class Answer < ApplicationRecord
  belongs_to :category

  validates :term, presence: true, uniqueness: { scope: :category }

  after_initialize :set_ranking, if: :new_record?

  def set_ranking
    self.ranking ||= (self.class.in_category(category).maximum(:ranking) || 0) + 1
  end

  scope :in_category, -> (category) { where(category: category) }
end
