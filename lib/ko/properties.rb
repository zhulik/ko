# frozen_string_literal: true

module KO
  module Properties
    def property(name, type, value: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      types = [type].flatten
      value ||= type.new if type.is_a?(Class)

      raise TypeError if types.none? { value.is_a?(_1) }

      signal :"#{name}_changed", type

      define_method(name) do
        @properties ||= {}
        return @properties[name] if @properties.key?(name)

        @properties[name] = value
        value
      end

      define_method("#{name}=") do |new_value|
        @properties ||= {}
        raise TypeError if types.none? { value.is_a?(_1) }

        return new_value if new_value == @properties[name]

        @properties[name] = new_value
        signals[:"#{name}_changed"].emit(new_value)
        new_value
      end
    end
  end
end
