# frozen_string_literal: true

module KO
  module Properties
    def property(name, type, value: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      types = [type].flatten
      value ||= type.new if type.is_a?(Class)

      raise TypeError if types.none? { value.is_a?(_1) }

      signal :"#{name}_changed", type
      var_name = "@#{name}"

      define_method(name) do
        return instance_variable_get(var_name) if instance_variable_defined?(var_name)

        instance_variable_set(var_name, value)
      end

      define_method("#{name}=") do |new_value|
        raise TypeError if types.none? { value.is_a?(_1) }

        return new_value if new_value == instance_variable_get(var_name)

        instance_variable_set(var_name, new_value)
        signals[:"#{name}_changed"].emit(new_value)
        new_value
      end
    end
  end
end
