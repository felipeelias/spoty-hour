class PlaylistView
  def initialize(tracks, start_time)
    @tracks       = tracks
    @start_time   = start_time
    @time_elapsed = 0
  end

  def build_one(index, track)
    artists  = track.fetch("artists")
    album    = track.fetch("album")
    duration = track.fetch("duration_ms").to_f
    @time_elapsed += duration

    {
      index: index,
      name: track.fetch("name"),
      popularity: track.fetch("popularity"),
      formatted_duration: format_time(duration),
      album_name: album.fetch("name"),
      artists: artists.map { |a| a.fetch("name") },
      total_duration_ms: @time_elapsed,
      plays_at: add_ms_to_time(@start_time, @time_elapsed),
    }
  end

  def render
    @tracks.map.with_index do |item, index|
      build_one(index, item.fetch("track"))
    end
  end

  private

  def format_time(ms)
    minutes = (ms / 1000 / 60) % 60
    seconds = (ms / 1000) % 60
    "%02d:%02d" % [minutes.to_i, seconds.round]
  end

  def add_ms_to_time(start_time, durations)
    Time.at(start_time.to_f + durations.to_f / 1000)
  end
end
