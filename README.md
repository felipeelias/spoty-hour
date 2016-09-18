# Spoty-Hour

This is a fun project that I developed to solve one very specific issue:

I was creating a playlist for my wedding party and I wanted to know at which time a song would play,
given that the party started at a specific time.

Since Spotify does not have that, I made this 😅

With that I could see that, for example, `Animals - Martin Garrix` would play at `00:03:49`. Right
at the peak of the party!

The URL for you to try yourself is:

```
http://localhost:4567/<your-username>/<playlist_id>?start_time=20:00:00
```

## Design

The app is very simple, but still there are few design points that I found interesting, and I plan
to reuse on other Ruby apps:

- `Request` abstraction that can be reused for `JsonClient` and for `Webmock` stubs
- Simple configuration management with `Configuration` class
- View classes hold the presentation logic, so templates are as simple as possible
- `MultiJson` gem that lets you change JSON parsers while keeping the API consistent

## Configuration

First, make sure you [create an application on Spotify][spotify-app].

Then, you'll need to configure a few environment variables in order for the app to work. I would
recommend creating a `.env` file in the root folder, with:

```bash
export SPOTIFY_CLIENT_ID=...
export SPOTIFY_CLIENT_SECRET=..
# Optional
export RACK_SESSION_SECRET=...
```

And load it with

```bash
source .env
```

## Setup

Setup the app with `bundle install`.

## Running the server

```ruby
rackup config.ru
```

## Debugging

If you're running the server locally and want to check what kind of requests are made to Spotify
API, start the server with:

```
RESTCLIENT_LOG=stdout rackup config.ru
```

And you'll be able to see the requests that are made on your console.

[spotify-app]: https://developer.spotify.com/my-applications/#!/applications/create
