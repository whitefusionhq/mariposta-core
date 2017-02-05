require 'safe_yaml'

class Mariposta::File
  # thank you Jekyll!
  YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

  attr_accessor :front_matter,
                :content,
                :path

  def self.read(file_path, using_fmm:)
    obj = new(using_fmm: using_fmm)
    obj.path = file_path
    file_data = File.read(file_path)
    loaded_attributes = {}

    begin
      if file_data =~ YAML_FRONT_MATTER_REGEXP
        obj.content = $'
        loaded_attributes = ::SafeYAML.load(Regexp.last_match(1))
      end
    rescue SyntaxError => e
      Rails.logger.error "Error: YAML Exception reading #{file_path}: #{e.message}"
    end

    if loaded_attributes.present?
      obj.front_matter.attributes = loaded_attributes
    end

    obj
  end

  def initialize(using_fmm:)
    self.front_matter = using_fmm.new
  end

  def generate_output
    front_matter.as_yaml + "---\n\n" + content
  end

  def save(force_path=nil)
    use_path = force_path || path
    if use_path.blank?
      raise "Must specify a file path"
    end

    File.open(use_path, 'w') do |f|
      f.write(generate_output)
    end

    Mariposta::Repository.current.add(use_path)

    true
  end
end
