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
      end
    end
  end
  def update_variables(hash)
    self.attributes = hash
  end
  
  def attributes
    ret = {}
    self.class.variable_names.each do |var_name|
      ret[var_name.to_s] = nil
    end
    ret
  end
end
