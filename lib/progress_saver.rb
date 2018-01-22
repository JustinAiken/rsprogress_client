class ProgressSaver
  include UsesClient

  def self.save!
    self.new.save!
  end

  def save!
    exit 1 unless minutes_played > 0

    profile.copy_to_repo!
    profile.stage!
    profile.commit! minutes_played: minutes_played
  end

private

  def profile
    @profile ||= ProfileBackup.new(CONFIG["save_game"]["repo"])
  end

  def minutes_played
    @minutes_played ||= client.profile[:steam_mins]
  end
end
