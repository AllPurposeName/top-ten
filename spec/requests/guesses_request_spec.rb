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

    context 'when a supplied category is not valid' do
      let(:category_dog_breeds) { Category.create!(name: 'dog_breeds') }
      subject(:make_request) do
        post '/guesses', params: { category: (category_dog_breeds.name), term: term }
      end

      let(:expected_message) { "We do not support that category. Try one of #{ClientFactory.categories}" }
      let(:expected_error_code) { '004' }
      it_behaves_like('errors are handled')
    end

    context 'music client failure' do
      let(:expected_message) { 'The external music library could not be reached at this moment' }
      let(:expected_error_code) { '101' }
      let!(:unanswered_answer) {Answer.create!(category: category_music, term: 'pink floyd') }
      class FailingMusicClientMock
        MusicClientError = Class.new(ErrorService::BasicError) do
          define_method(:external_message) { 'The external music library could not be reached at this moment' }
          define_method(:error_code) { '101' }
        end
        def search(search_term:)
          raise MusicClientError
        end
      end

      before do
        TopTen::Application.config.music_client = 'FailingMusicClientMock'
      end

      subject(:make_request) do
        post '/guesses', params: { category: category_music.name, term: term }
      end

      it_behaves_like('errors are handled')
      end
    end
  end
