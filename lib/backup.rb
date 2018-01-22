class Backup
  include UsesClient

  def self.flags!
    self.new.flags!
  end

  def self.notes!
    self.new.notes!
  end

  def flags!
    flag_yml = client.get_flags.inject({}) do |memo, flag_data|
      memo[flag_data[:name]] = {id: flag_data[:id], happened_at: flag_data[:happened_at] }
      memo
    end

    write! name: :flags, data: flag_yml
  end

  def notes!
    notes_yml = client.get_notes.inject({}) do |memo, note_data|
      memo[note_data[:name]] = {id: note_data[:id], body: note_data[:body] }
      memo
    end

    write! name: :notes, data: notes_yml
  end

private

  def write!(data:, name:)
    File.open("config/#{name}.yml", "w") { |f| f.write data.to_yaml }
  end
end
