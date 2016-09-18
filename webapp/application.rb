require './config/environment'

class SpotyHourApp < Sinatra::Base
  set :sessions,    secret: Config.fetch(:rack_session_secret)
  set :views,       Proc.new { File.join(root, "../webapp/templates") }
  set :spotify_api, Proc.new { SpotifyClient.new }

  get '/' do
    "If you're seeing this, we couldn't authorize your request with Spotify 😞"
  end

  get '/:username/:playlist_id' do
    with_access_token do |token|
      username    = params.fetch("username")
      playlist_id = params.fetch("playlist_id")
      start_time  = params.fetch("start_time") { Time.now.utc.to_s }
      start_time  = Time.parse(start_time)

      songs  = spotify_api.get_playlist_songs(token, username, playlist_id)
      tracks = PlaylistView.new(songs, start_time).render
      haml :index, locals: { tracks: tracks, start_time: start_time }
    end
  end

  private

  def spotify_api
    settings.spotify_api
  end

  def with_access_token
    begin
      session[:access_token] ||= spotify_api.get_token
      yield session[:access_token]
    rescue RestClient::Unauthorized
      session[:access_token] = nil
      redirect to("/")
    end
  end
end
