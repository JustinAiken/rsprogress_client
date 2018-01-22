require "singleton"

class GitRepo
  include Singleton

  attr_accessor :repo

  def initialize
    @repo = Git.open CONFIG["save_game"]["repo"]
  end

  def self.repo
    instance.repo
  end

  class << self
    delegate :checkout, :log, :dir, to: :repo
  end
end
