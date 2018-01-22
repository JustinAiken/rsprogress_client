class SavedGameInTime

  COMMIT_MESSAGE_REGEX = /(?<timestamp>\d{10}) - (?<steam_minutes>\d{5})/

  attr_accessor :git_log

  def initialize(git_log)
    @git_log = git_log
    puts "Processing.. #{git_log.message}"
    GitRepo.checkout git_log.sha
  rescue
    @invalid = true
  end

  def valid?
    !@invalid && matches && steam_minutes && timestamp && game
  rescue
    false
  end

  def game
    @game ||= RSGuitarTech::SavedGame.from("#{GitRepo.dir.path}/#{RSGuitarTech::Steam.new.save_filename}")
  end

  def steam_minutes
    matches[:steam_minutes].to_i
  end

  def timestamp
    matches[:timestamp].to_i
  end

  def matches
    git_log.message.match COMMIT_MESSAGE_REGEX
  end
end
