class Mariposta::SiteConfig
  attr_accessor :data

  def initialize(config_file_path)
    config_file = File.read(config_file_path)
    self.data = ::SafeYAML.load(config_file)
  end
end
