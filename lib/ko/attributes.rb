# frozen_string_literal: true

module KO
  module Attributes
    # TODO: typecheck for default
    def attribute(name, type, value: nil)
      value ||= type.new

      define_method(name) do
        var_name = "@#{name}"

        return instance_variable_get(var_name) if instance_variable_defined?(var_name)

        instance_variable_set(var_name, value)
      end

      # TODO: typecheck
      define_method("#{name}=") do |new_value|
        instance_variable_set("@#{name}", new_value)
      end
    end
  end
end
