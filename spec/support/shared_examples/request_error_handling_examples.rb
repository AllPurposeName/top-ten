RSpec.shared_examples 'errors are handled' do
  it 'returns the correct error' do
    make_request
    resp       = JSON.parse(response.body)
    message    = resp['message']
    error_code = resp['error_code']
    status_code = response.status

    expect(message).to eq(expected_message)
    expect(error_code).to eq(expected_error_code)
    expect(status_code).to eq(expected_status_code)
  end
end
