require 'rack/test'
require './spec/support/spotify_client_stubs'
require './webapp/application'

RSpec.describe SpotyHourApp do
  include Rack::Test::Methods
  include SpotifyClientStubs

  def app
    SpotyHourApp
  end

  let(:username)     { 'username' }
  let(:playlist_id)  { 'playlist-id' }
  let(:access_token) { 'access-token' }

  describe 'requesting an access token' do
    it 'redirects when is not authenticated' do
      stub_token_request { |request| { status: 401 } }

      get "/#{username}/#{playlist_id}"
      expect(last_response).to be_redirect

      follow_redirect!
      expect(last_response).to be_ok
    end

    it 'stores the access token if authentication succeeds' do
      stub_token_request do |request|
        { status: 200, body: MultiJson.dump({access_token: access_token}) }
      end

      stub_playlist_request(access_token, username, playlist_id) do |request|
        { body: MultiJson.dump({next: nil, items: []}) }
      end

      get "/#{username}/#{playlist_id}"

      expect(last_response).to be_ok
      expect(last_request.env['rack.session']['access_token']).to eq access_token
    end
  end

  context 'with access token' do
    before do
      env('rack.session', {access_token: access_token})

      stub_playlist_request(access_token, username, playlist_id) do |request|
        { body: MultiJson.dump({next: nil, items: []}) }
      end
    end

    it 'does not call authentication endpoint' do
      request = stub_token_request
      get "/#{username}/#{playlist_id}"
      expect(request).to have_not_been_made
    end

    it 'returns ok status' do
      get "/#{username}/#{playlist_id}"
      expect(last_response).to be_ok
    end

    it 'tells when the party is about to start' do
      get "/#{username}/#{playlist_id}?start_time=20:00:00"
      expect(body).to match(/Party starts at\s*20:00/)
    end

    it 'shows the songs on the playlist' do
      stub_playlist_request(access_token, username, playlist_id) do |request|
        { body: MultiJson.dump({
            next: nil,
            items: [
              track: {
                album: { name: "Amazing Album" },
                artists: [{ name: "Great Artist" }],
                duration_ms: 125 * 1000,
                name: 'Wonderful Song',
                popularity: 100,
              }
            ],
          })
        }
      end

      get "/#{username}/#{playlist_id}?start_time=19:59:59"

      expect(body).to match(/Amazing Album/)
      expect(body).to match(/Wonderful Song/)
      expect(body).to match(/Great Artist/)
      expect(body).to match(/02:05/)
      expect(body).to match(/20:02:04/)
    end
  end

  def body
    last_response.body
  end
end
