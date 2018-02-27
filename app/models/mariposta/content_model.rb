require 'safe_yaml'

class Mariposta::ContentModel
  include ActiveModel::Model
  include Mariposta::Serializers::YAML
  extend Mariposta::VariableDefinitions

  attr_accessor :file_path, :content

  # code snippet from Jekyll
  YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

  def self.find(file_path)
    new(file_path: file_path).tap do |content_model|
      content_model.load_file_from_path
    end
  end

  def save(force_file_path=nil)
    file_path_to_use = force_file_path || file_path
    if file_path_to_use.blank?
      raise "Must specify a file path"
    end

    File.open(file_path_to_use, 'w') do |f|
      f.write(generate_file_output)
    end

    Mariposta::Repository.current&.add(file_path_to_use)

    true
  end

  def persisted?
    file_path.present?
  end

  def file_name
    file_path&.split('/')&.last
  end

  def generate_file_output
    as_yaml + "---\n\n" + content.to_s
  end

  def variable_names
    @variable_names ||= self.class.variable_names&.dup || []
  end

  def attributes
    ret = {}
    variable_names.each do |var_name|
      ret[var_name.to_s] = nil
    end
    ret
  end

  def assign_attributes(new_attributes)
    # Changed from Active Model
    # (we implement our own method of assigning attributes)

    if !new_attributes.respond_to?(:stringify_keys)
      raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
    end
    return if new_attributes.empty?

    attributes = new_attributes.stringify_keys
    update_variables(sanitize_for_mass_assignment(attributes))
  end

  def update_variables(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue NoMethodError
        Rails.logger.warn (":#{key}: is not a defined attribute, will be available as read-only")

        # If an unfamiliar attribute is present, allow it to be set as a
        # read-only value for future serialization, but it still can't be set
        # via an accessor writer. Kind ugly code, but it works
        instance_variable_set("@#{key}", value)
        unless key.to_sym.in? variable_names
          variable_names << key.to_sym
          define_singleton_method key.to_sym do
            instance_variable_get("@#{key}")
          end
        end
      end
    end
  end

  def load_file_from_path
#    begin
      file_data = File.read(file_path)
#    rescue SystemCallError
#      raise MissingContentError.new()
#    end

    loaded_attributes = {}

    begin
      if file_data =~ YAML_FRONT_MATTER_REGEXP
        self.content = $'
        loaded_attributes = ::SafeYAML.load(Regexp.last_match(1))
      end
    rescue SyntaxError => e
      Rails.logger.error "Error: YAML Exception reading #{file_path}: #{e.message}"
    end

    if loaded_attributes.present?
      update_variables(loaded_attributes)
    end
  end

end
