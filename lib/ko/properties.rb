# frozen_string_literal: true

module KO
  module Properties
    def property(name, type, value: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      types = [type].flatten
      value ||= type.new if type.is_a?(Class)

      raise TypeError if types.none? { value.is_a?(_1) }

      signal :"#{name}_changed", type

      define_method(name) do
        return properties[name] if properties.key?(name)

        properties[name] = value
      end

      define_method("#{name}=") do |new_value|
        raise TypeError if types.none? { value.is_a?(_1) }

        return new_value if new_value == properties[name]

        properties[name] = new_value
        signals[:"#{name}_changed"].emit(new_value)
        new_value
      end
    end

    module InstanceMethods
      def bind(prop_name, from, from_prop_name)
        setter = method("#{prop_name}=")
        setter.call(from.send(from_prop_name))

        from.send("#{from_prop_name}_changed").connect(setter)
      end

      def properties = @properties ||= {}
    end

    def self.extended(base)
      base.include(InstanceMethods)
    end
  end
end
