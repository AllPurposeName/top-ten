RSpec.shared_examples 'errors are handled' do
  it 'returns the correct error' do
    make_request
    resp       = JSON.parse(response.body)
    message    = resp['message']
    error_code = resp['error_code']

    expect(message).to eq(expected_message)
    expect(error_code).to eq(expected_error_code)
  end
end
