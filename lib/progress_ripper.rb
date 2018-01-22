class ProgressRipper
  include UsesClient

  def self.rip!(n: 1)
    GitRepo.log(n).reverse_each do |log|
      process! log: log
    end
  ensure
    GitRepo.checkout "master"
  end

  def self.process!(log:)
    sgit = SavedGameInTime.new(log)
    return unless sgit.valid?

    self.new(sgit).rip!.post_and_show!
  end

  attr_accessor :game, :progress_attributes
  delegate :song_statistics, :score_attack, to: :game

  STATS_TO_RIP = %i{
    session_seconds
    games_seconds
    lesson_second
    las_seconds
    rs_seconds
    missions_completed
    session_count
    songs_played_count
    session_mission_time
    longest_streak
  }

  def initialize(sgit)
    @game = sgit.game
    @progress_attributes = {
      steam_mins: sgit.steam_minutes,
      ended_at:   DateTime.strptime(sgit.timestamp.to_s, "%s")
    }
    STATS_TO_RIP.each do |key|
      @progress_attributes[key] = sgit.game.statistics.send(key).to_i
    end
  end

  def rip!
    progress_attributes[:arrangement_progresses_attributes] = song_statistics
      .values
      .map do |ss|
        arrangement_progress_attributes_from(ss).merge(
          score_info_for(ss.id)
        )
      end
      .compact
      .reject { |hash| hash.values[1..-1].all? &:nil? }

    self
  end

  def post_and_show!
    id = client.post_progress(progress_attributes)
    if id
      client.show_progress id
    else
      puts "fail!"
    end
  end

private

  def arrangement_progress_attributes_from(song_stat)
    {
      identifier:     song_stat.id,
      play_count:     song_stat.played_count,
      mastery:        song_stat.mastery_peak,
      date_sa:        song_stat.date_sa,
      date_las:       song_stat.date_las,
      streak:         song_stat.streak
    }
  end

  def score_info_for(identifier)
    return {} unless score_info = score_attack[identifier]
    {
      sa_play_count:   score_info.play_count,
      sa_score_easy:   score_info.high_scores["Easy"],
      sa_score_medium: score_info.high_scores["Medium"],
      sa_score_hard:   score_info.high_scores["Hard"],
      sa_score_master: score_info.high_scores["Master"]
    }.tap do |hash|
      hash[:sa_pick_easy]    = score_info.picks["Easy"].to_i   if score_info.picks["Easy"].to_i > 0
      hash[:sa_pick_medium]  = score_info.picks["Medium"].to_i if score_info.picks["Medium"].to_i > 0
      hash[:sa_pick_hard]    = score_info.picks["Hard"].to_i   if score_info.picks["Hard"].to_i > 0
      hash[:sa_pick_master]  = score_info.picks["Master"].to_i if score_info.picks["Master"].to_i > 0
    end
  end
end
