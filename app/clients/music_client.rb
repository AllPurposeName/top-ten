class MusicClient
  cattr_reader :client_failure_error do ErrorService.build(
    name: 'MusicClientFailureError',
    base: 'ClientError',
    message: 'The external music library could not be reached at this moment',
    code: '101'
  )
  end

  MUSIC_URL = 'https://www.theaudiodb.com/api/v1/json/1/search.php'
  MusicClientError = Class.new(StandardError)
  attr_reader :client
  def initialize(client: RestClient)
    @client = client
  end
  def search(search_term:)

    Rails.logger.debug("Searching Music library for #{search_term}")
    response = client.get(
      MUSIC_URL,
      params: { s: search_term }
    )

    artist = JSON.parse(response.body)['artists'].first
    {
      name: artist['strArtist'],
      publisher: artist['strLabel'],
      genre: artist['strGenre'],
    }
  rescue RestClientError => error
    raise MusicClientError, error.message
  end
end
