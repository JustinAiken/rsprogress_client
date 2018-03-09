require_relative "boot"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new :spec
  task default: :spec
rescue LoadError
  # no rspec available
end

namespace :progress do
  desc "Backup saved game"
  task :save do
    ProgressSaver.save!
  end

  desc "Rip and report last saved game"
  task :rip do
    ProgressRipper.rip!
  end

  desc "Rip and report last n saved games"
  task :rip_multiple do
    fail "Usage: progress:rip_multiple 10" unless ARGV[1]
    ARGV.each { |a| task a.to_sym do ; end }
    ProgressRipper.rip! n: ARGV[1].to_i
  end
end

namespace :flags do
  desc "Backup all flags into a yml file"
  task :backup do
    Backup.flags!
  end

  desc "Post all saved flags to server"
  task :restore do
    Restore.flags!
  end
end

namespace :notes do
  desc "Backup all notes into a yml file"
  task :backup do
    Backup.notes!
  end

  desc "Post all saved notes to server"
  task :restore do
    Restore.notes!
  end
end

desc "Rip configured arrangements"
task :rip_arrangements do
  ArrangementRipper.rip!
end
