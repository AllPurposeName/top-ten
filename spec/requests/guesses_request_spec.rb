require 'rails_helper'

RSpec.describe "Guesses", type: :request do
  let!(:category_music) { Category.create!(name: 'music') }
  let(:term) { 'whichwhich' }

  describe 'error states' do

    context 'when a guess is not supplied a category' do
      subject(:make_request) do
        post '/guesses', params: { term: term }
      end

      let(:expected_message) { 'Category needs to be supplied' }
      let(:expected_error_code) { '001' }
      it_behaves_like('errors are handled')
    end

    context 'when a guess term has been duplicated' do
      let!(:existing_guess) { Guess.create!(category: category_music, term: term) }
      subject(:make_request) do
        post '/guesses', params: { category: category_music.name, term: term }
      end
      let(:expected_message) { 'You have already guessed that term' }
      let(:expected_error_code) { '002' }
      it_behaves_like('errors are handled')
    end

    context 'when a guess is not supplied a term' do
      subject(:make_request) do
        post '/guesses', params: { category: category_music.name }
      end

      let(:expected_message) { 'Term needs to be supplied' }
      let(:expected_error_code) { '003' }
      it_behaves_like('errors are handled')
    end

  end
end
