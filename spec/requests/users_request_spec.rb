require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'error states' do

    context 'when a user name is not supplied' do
      subject(:make_request) do
        post '/users', params: { }

        let(:expected_message)     { 'No user name provided. Ensure you read the readme!' }
        let(:expected_error_code)  { '203' }
        let(:expected_status_code) { 422 }
        it_behaves_like('errors are handled')
      end
    end

    context 'when a user name is not unique' do
      let!(:existing_user) { User.create!(name: 'Derek Yu', public_key: '1', private_key: 'a') }
      subject(:make_request) do
        post '/users', params: { name: 'Derek Yu'}

        let(:expected_message)     { 'No user name provided. Ensure you read the readme!' }
        let(:expected_error_code)  { '203' }
        let(:expected_status_code) { 422 }
        it_behaves_like('errors are handled')
      end
    end
  end
end
