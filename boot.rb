require "yaml"

require "active_support"
require "pry"
require "httparty"
require "git"
require "rsgt"

require_relative "lib/progress_client"
require_relative "lib/uses_client"
require_relative "lib/backup"
require_relative "lib/restore"
require_relative "lib/progress_saver"
require_relative "lib/unpacked_dir"
require_relative "lib/profile_backup"
require_relative "lib/saved_game_in_time"
require_relative "lib/progress_ripper"
require_relative "lib/git_repo"
require_relative "lib/arrangement_ripper"

CONFIG = YAML.load_file("config/config.yml").with_indifferent_access
