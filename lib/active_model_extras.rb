# require 'active_support/core_ext/class/attribute'
require 'active_model'

module ActiveModel
  # == Active Model YAML Serializer
  module Serializers
    module YAML
      extend ActiveSupport::Concern
      include ActiveModel::Serialization

      included do
        extend ActiveModel::Naming

        class_attribute :include_root_in_json
        self.include_root_in_json = false
      end

      module ClassMethods
        def new_from_yaml(yml)
          new.from_yaml(yml)
        end
      end

      # Same thing as as_json, but returns yaml instead of a hash (unless you include the as_hash:true option)
      def as_yaml(options = {})
        as_hash = options.delete(:as_hash)
        hash = serializable_hash(options)

        if include_root_in_json
          custom_root = options && options[:root]
          hash = { custom_root || self.class.model_name.element => hash }
        end

        as_hash ? hash : hash.to_yaml
      end

      def from_yaml(yaml)
        hash = SafeYAML.load(yaml)
        hash = hash.values.first if include_root_in_json
        self.attributes = hash
        self
      end
    end
  end
end

module ActiveModel
  module VariableDefinitions

    def variables(*names_arr)
      @variable_names = names_arr
      names_arr.each do |var_name|
        attr_accessor var_name
      end
    end

    def variable_names
      @variable_names
    end

  end
end
