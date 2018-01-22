class UnpackedDir

  attr_accessor :name, :path, :dlc_type

  def initialize(name, path, dlc_type)
    @name, @path, @dlc_type = name, path, dlc_type
  end

  def self.all
    @unpacked ||= CONFIG[:psarcs].map do |config_data|
      UnpackedDir.new config_data["name"], config_data["path"], config_data["dlc_type"]
    end
  end

  def files
    Dir[path].reject { |filename| filename =~ /Vocal/i }
  end

  def count
    files.count
  end
end
