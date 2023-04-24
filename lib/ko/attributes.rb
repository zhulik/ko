# frozen_string_literal: true

module KO
  module Attributes
    def attribute(name, type, value: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      types = [type].flatten
      value ||= type.new if type.is_a?(Class)

      raise TypeError if types.none? { value.is_a?(_1) }

      signal :"#{name}_changed", type

      define_method(name) do
        var_name = "@#{name}"

        return instance_variable_get(var_name) if instance_variable_defined?(var_name)

        instance_variable_set(var_name, value)
      end

      define_method("#{name}=") do |new_value|
        raise TypeError if types.none? { value.is_a?(_1) }

        var_name = "@#{name}"

        return new_value if new_value == instance_variable_get(var_name)

        instance_variable_set(var_name, new_value).tap do
          signals[:"#{name}_changed"].emit(new_value)
        end
      end
    end
  end
end
