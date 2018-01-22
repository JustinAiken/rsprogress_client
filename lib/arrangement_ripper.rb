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
    else
      puts "#{filename}: failed with code #{response.code}"
    end
  end
end
