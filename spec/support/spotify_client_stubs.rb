module SpotifyClientStubs
  def stub_token_request(&block)
    request = app.spotify_api.token_request
    stub_request(request.method, request.url).
      with(body: request.body, headers: request.headers).
      to_return(&block)
  end

  def stub_playlist_request(access_token, username, playlist_id, &block)
    request = app.spotify_api.playlist_request(access_token, username, playlist_id)
    stub_request(request.method, request.url).
      with(headers: request.headers).
      to_return(&block)
  end
end
