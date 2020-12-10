class ClientFactory
  def build(category_name:)
    clients[category_name].new
  end

  def categories
    clients.keys
  end

  def clients
    {
      'music' => TopTen::Application.config.music_client.constantize,
    }
  end
end
