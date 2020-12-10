require 'rails_helper'

RSpec.describe Guess, type: :model do
  describe '#term' do
    context 'uniqueness' do
      let(:category_video_games) { Category.create!(name: 'video games') }
      let(:category_movies)      { Category.create!(name: 'movies') }
      it 'applies within a same category' do
        _base_answer = Guess.create!(category: category_video_games, term: 'spelunky')
        actual       = Guess.new(category: category_video_games, term: 'spelunky')
        expect(actual).not_to be_valid

      end
      it 'respects categories' do
        _base_answer = Guess.create!(category: category_movies, term: 'magnolia')
        actual       = Guess.new(category: category_video_games, term: 'spelunky')
        expect(actual).to be_valid
      end
    end
  end
end
