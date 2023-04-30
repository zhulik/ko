# frozen_string_literal: true

module KO
  module Properties
    def property(name, type, value: nil, on_change: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      types = [type].flatten
      value ||= type.new if type.is_a?(Class)

      raise TypeError if types.none? { value.is_a?(_1) }

      signal :"#{name}_changed", type

      define_method(name) do
        return properties[name] if properties.key?(name)

        properties[name] = value
      end

      define_method("#{name}=") do |new_value|
        return new_value.apply(self, name) if new_value.is_a?(Binding)
        raise TypeError if types.none? { new_value.is_a?(_1) }

        return new_value if new_value == properties[name]

        properties[name] = new_value
        send(on_change) if on_change
        signals[:"#{name}_changed"].emit(new_value)
        new_value
      end
    end

    module InstanceMethods
      def bind(target_or_prop_name = nil, prop_name = nil)
        return Binding.new(self, target_or_prop_name) if target_or_prop_name.is_a?(Symbol)

        raise ArgumentError if prop_name.nil?

        Binding.new(target_or_prop_name, prop_name)
      end

      def assign_properties(val = {}, **props) = val.merge(props).each { send("#{_1}=", _2) }

      def properties = @properties ||= {}
    end

    def self.extended(base)
      base.include(InstanceMethods)
    end
  end
end
