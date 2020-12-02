require 'rails_helper'

RSpec.describe "Guesses", type: :request do
  let!(:category_music) { Category.create!(name: 'music') }
  let(:term) { 'whichwhich' }

  describe 'error states' do
    context 'when a guess is not supplied a category' do
      subject(:make_request) do
        post '/guesses', params: { term: term }
      end

      let(:expected_message)     { 'Category needs to be supplied' }
      let(:expected_error_code)  { '001' }
      let(:expected_status_code) { 422 }
      it_behaves_like('errors are handled')
    end

    context 'when a guess term has been duplicated' do
      let!(:existing_guess) { Guess.create!(category: category_music, term: term) }
      subject(:make_request) do
        post '/guesses', params: { category: category_music.name, term: term }
      end
      let(:expected_message)     { 'You have already guessed that term' }
      let(:expected_error_code)  { '002' }
      let(:expected_status_code) { 409 }
      it_behaves_like('errors are handled')
    end

    context 'when a guess is not supplied a term' do
      subject(:make_request) do
        post '/guesses', params: { category: category_music.name }
      end

      let(:expected_message)     { 'Term needs to be supplied' }
      let(:expected_error_code)  { '003' }
      let(:expected_status_code) { 422 }
      it_behaves_like('errors are handled')
    end

    context 'when a supplied category is not valid' do
      let(:category_dog_breeds) { Category.create!(name: 'dog_breeds') }
      subject(:make_request) do
        post '/guesses', params: { category: (category_dog_breeds.name), term: term }
      end

      let(:expected_message)     { "We do not support that category. Try one of #{ClientFactory.new.categories}" }
      let(:expected_error_code)  { '004' }
      let(:expected_status_code) { 422 }
      it_behaves_like('errors are handled')
    end

    context 'music client failure' do
      let(:expected_message)     { 'The external music library could not be reached at this moment' }
      let(:expected_error_code)  { '101' }
      let(:expected_status_code) { 424 }
      let!(:unanswered_answer)   { Answer.create!(category: category_music, term: 'pink floyd') }
      class FailingMusicClientMock
        MusicClientError = Class.new(ErrorService::BasicError) do
          define_method(:external_message) { 'The external music library could not be reached at this moment' }
          define_method(:error_code)       { '101' }
          define_method(:http_status_code) { 424 }
        end
        def search(search_term:)
          raise MusicClientError
        end
      end

      before do
        TopTen::Application.config.stub(:music_client).and_return('FailingMusicClientMock')
      end

      subject(:make_request) do
        post '/guesses', params: { category: category_music.name, term: term }
      end

      it_behaves_like('errors are handled')
    end

    context 'video game client failure' do
      let(:category_video_game) { Category.create!(name: 'video games') }
      let(:expected_message)     { 'The external video game library could not be reached at this moment' }
      let(:expected_error_code)  { '102' }
      let(:expected_status_code) { 424 }
      let!(:unanswered_answer)   { Answer.create!(category: category_video_game, term: 'spelunky') }
      class FailingVideoGameClientMock
        VideoGameClientError = Class.new(ErrorService::BasicError) do
          define_method(:external_message) { 'The external video game library could not be reached at this moment' }
          define_method(:error_code)       { '102' }
          define_method(:http_status_code) { 424 }
        end
        def search(search_term:)
          raise VideoGameClientError
        end
      end

      before do
        TopTen::Application.config.stub(:video_game_client).and_return('FailingVideoGameClientMock')
      end

      subject(:make_request) do
        post '/guesses', params: { category: category_video_game.name, term: term }
      end

      it_behaves_like('errors are handled')
    end

    context 'authed user correctly guesses same answer twice' do
      let(:user) { User.create!(name: 'Karl', public_key: '1', private_key: 'a') }
      let(:variant_term) { 'the beat alls' }
      let(:answer) { Answer.create!(category: category_music, term: 'the beatles', variants: [variant_term]) }
      let!(:existing_user_answer) { UserAnswer.create!(user_id: user.id, answer_id: answer.id) }
      subject(:make_request) do
        post '/guesses', params: { category: category_music.name, term: variant_term, user_name: user.name }
      end
      let(:expected_message)     { 'You already correctly guessed that answer! Try again. This guess did not count against you.' }
      let(:expected_error_code)  { '005' }
      let(:expected_status_code) { 409 }

      it_behaves_like('errors are handled')
    end

    context 'when signing a request' do
      let(:user) { User.create!(name: 'Derek Yu', public_key: '1', private_key: 'a') }
      let(:authorization) do
        calculated_hmac = Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            'sha256',
            user.private_key,
            ({ category: category_music.name, term: term }.to_json + ':' + user.public_key)
          )
        )
      end

      before do
        TopTen::Application.config.stub(:authentication_service).and_return('AuthenticationService')
      end

      context 'without a valid user' do
        subject(:make_request) do
          post '/guesses', params: { category: category_music.name, term: term }, headers: { authorization: authorization }
        end

        let(:expected_message)     { 'No user name provided. Please provide one in the query parameters' }
        let(:expected_error_code)  { '202' }
        let(:expected_status_code) { 403 }

        it_behaves_like('errors are handled')
      end

      context 'without a valid signed message' do
        let(:bad_authorization) do
          calculated_hmac = Base64.strict_encode64(
            OpenSSL::HMAC.digest(
              'sha256',
              user.private_key,
              (user.public_key + ':' + { category: category_music.name, term: term }.to_json)
            )
          )
        end
        subject(:make_request) do
          post '/guesses', params: { category: category_music.name, term: term, user_name: user.name }, headers: { authorization: bad_authorization }
        end

        let(:expected_message)     { 'Your authorization key does not match ours. Ensure you read the readme!' }
        let(:expected_error_code)  { '201' }
        let(:expected_status_code) { 403 }

        it_behaves_like('errors are handled')
      end
    end
  end
end
