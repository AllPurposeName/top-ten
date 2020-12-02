class ClientFactory
  CLIENTS = {
    'music' => const_get(TopTen::Application.config.music_client),
  }

  def self.build(category_name:)
    CLIENTS[category_name].new
  end

  def self.categories
    CLIENTS.keys
  end
end
