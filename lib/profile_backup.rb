class ProfileBackup

  attr_accessor :save_repo, :git

  def initialize(save_repo)
    @save_repo = save_repo
    @git       = Git.open save_repo
  end

  def copy_to_repo!
    FileUtils.cp save_file, save_repo
  end

  def stage!
    git.add all: true
  end

  def commit!(minutes_played:)
    commit_msg = "#{Time.now.to_i} - #{minutes_played}"
    git.commit commit_msg
    puts "Commited '#{commit_msg}'"
  rescue => e
    if e.message =~ /nothing to commit/
      puts "Nothing to commit! No progress to save"
      puts "...would have commited '#{commit_msg}' otherwise"
    end
  end

private

  def save_file
    @save_file ||= RSGuitarTech::Steam.new.save_file
  end
end
