require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:category_music)  { Category.create!(name: 'music') }
  let(:category_comics) { Category.create!(name: 'comics') }

  describe '#term' do
    context 'uniqueness' do
      it 'applies within a same category' do
        _base_answer = Answer.create!(category: category_comics, term: 'magneto')
        actual       = Answer.new(category: category_comics, term: 'magneto')
        expect(actual).not_to be_valid

      end
      it 'respects categories' do
        _base_answer = Answer.create!(category: category_music, term: 'magneto')
        actual       = Answer.new(category: category_comics, term: 'magneto')
        expect(actual).to be_valid
      end
    end
  end
  describe '#ranking' do
    context 'auto incrementing' do
      it 'happens if ranking is not supplied' do
        base_answer = Answer.create!(category: category_music, term: 'the beatles', ranking: 1)
        actual      = Answer.create!(category: category_music, term: 'pink floyd').ranking
        expected    = base_answer.ranking + 1
        expect(actual).to eq(expected)
      end

      it 'starts at one if no rankings are given' do
        actual   = Answer.create!(category: category_music, term: 'keane').ranking
        expected = 1
        expect(actual).to eq(expected)
      end

      it 'respects different categories having separate rankings' do
        wrong_category_answer = Answer.create!(category: category_music, term: 'the beatles', ranking: 1)
        actual                = Answer.create!(category: category_comics, term: 'pink floyd').ranking
        expected              = 1
        expect(actual).to eq(expected)
      end
    end
  end
end
