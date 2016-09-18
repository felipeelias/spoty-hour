class SpotifyClient
  def client_id
    Config.fetch(:spotify_client_id)
  end

  def client_secret
    Config.fetch(:spotify_client_secret)
  end

  def basic_auth
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def token_request
    url     = 'https://accounts.spotify.com/api/token'
    body    = { grant_type: 'client_credentials' }
    headers = { 'Authorization' => "Basic #{basic_auth}" }
    Request[:post, url, body, headers]
  end

  def playlist_request(access_token, username, playlist_id)
    url     = "https://api.spotify.com/v1/users/#{username}/playlists/#{playlist_id}/tracks"
    headers = { 'Authorization': "Bearer #{access_token}" }
    Request[:get, url, nil, headers]
  end

  def get_token
    response = JsonClient.execute(self.token_request)
    response.fetch('access_token')
  end

  def get_playlist_songs(access_token, username, playlist_id)
    request = self.playlist_request(access_token, username, playlist_id)
    items = []

    while request.url
      response = JsonClient.execute(request)
      request.url = response.fetch("next")
      items.concat(response.fetch("items"))
    end

    items
  end
end
