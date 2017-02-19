class Mariposta::FrontMatterModel
  include ActiveModel::Model
  include ActiveModel::Serializers::YAML
  extend ActiveModel::VariableDefinitions

  def attributes=(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue NoMethodError
        Rails.logger.warn (":#{key}: is not a valid attribute!")

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
  def update_variables(hash)
    self.attributes = hash
  end

  def variable_names
    @variable_names ||= self.class.variable_names.dup
  end

  def attributes
    ret = {}
    variable_names.each do |var_name|
      ret[var_name.to_s] = nil
    end
    ret
  end
end
