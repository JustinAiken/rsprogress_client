class ArrangementRipper
  include UsesClient

  def self.rip!
    self.new(UnpackedDir.all).rip!
  end

  attr_accessor :directories

  def initialize(directories)
    @directories = directories
  end

  def rip!
    directories.each { |dir| rip_dir dir }
  end

  def rip_dir(dir)
    puts "Ripping #{dir.name} (#{dir.count} arrangements)"

    dir.files.each do |filename|
      rip_file filename, dir: dir
    end
  end

  def rip_file(filename, dir:)
    response = client.post_arrangement type: dir.dlc_type, file: filename
    if response.code.to_s =~ /20\d/
      body = JSON.parse(response.body)
      puts "#{filename}: created arrangement #{body['id']}"
    elsif response.code.to_s == "422"
      response = client.update_arrangement type: dir.dlc_type, file: filename
      puts response.code
      puts response.body
    else
      puts "#{filename}: failed with code #{response.code}"
      puts "#{filename}: failed with code #{response.body}"
    end
  end
end
