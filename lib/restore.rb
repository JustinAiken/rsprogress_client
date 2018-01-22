class Restore
  include UsesClient

  def self.flags!
    self.new.flags!
  end

  def self.notes!
    self.new.notes!
  end

  def flags!
    YAML.load_file("config/flags.yml").each do |name, data|
      puts "Posting #{name} (#{data[:happened_at]})"
      response = client.post_flag(data[:id], data[:happened_at])
      puts response
      puts "--"
    end
  end

  def notes!
    YAML.load_file("config/notes.yml").each do |name, data|
      puts "Posting note about #{name}"
      response = client.post_note(data[:id], data[:body])
      puts response
      puts "--"
    end
  end
end
