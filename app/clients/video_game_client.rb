class VideoGameClient
  cattr_reader :client_failure_error do ErrorService.build(
    name: 'VideoGameClientFailureError',
    base: 'ClientError',
    message: 'The external video game library could not be reached at this moment',
    code: '102',
    http_status_code: 424
  )
  end

  VIDEO_GAME_SEARCH_URL = 'https://www.giantbomb.com/api/search/'
  VIDEO_GAME_SHOW_URL = 'https://www.giantbomb.com/api/game/'

  VideoGameClientError = Class.new(StandardError)
  attr_reader :client
  def initialize(client: RestClient)
    @client = client
  end

  def search(search_term:)
    Rails.logger.debug("Searching Video Game library for #{search_term}")
    Rails.cache.fetch("video_game_search/#{search_term}", expires_in: 5.hours) do
    search_response = client.get(
      VIDEO_GAME_SEARCH_URL,
      params: {
        query: search_term,
        resources: 'game',
        api_key: TopTen::Application.credentials.clients[:giant_bomb_api_key],
        format: 'json',
      }
    )

    guid = Array(JSON.parse(search_response)['results']).first['guid']

    game_response = client.get(
      VIDEO_GAME_SHOW_URL + guid,
      params: {
        api_key: TopTen::Application.credentials.clients[:giant_bomb_api_key],
        format: 'json',
      }
    )

    game = JSON.parse(game_response.body)['results']

    {
      name: game['name'],
      publisher: game['publishers'].first['name'],
      genre: game['genres'].sample['name'],
    }
    end
  rescue client::Exception => error
    Rails.cache.delete("video_game_search/#{search_term}")
    raise VideoGameClientError, error.message
  end
end
