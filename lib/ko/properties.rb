# frozen_string_literal: true

module KO
  module Properties
    def property(name, type, value: nil) # rubocop:disable Metrics/AbcSize
      signal_name = :"#{name}_changed"
      signal(signal_name, type)

      define_method(name) do
        (properties[name] ||= Property.new(name, type, value, self, signal_name)).value
      end

      define_method("#{name}=") do |new_value|
        return new_value.bind(self, name) if new_value.is_a?(Property)
        return properties[name].value = new_value if properties.key?(name)

        properties[name] = Property.new(name, type, new_value, self, signal_name)
      end
    end

    module InstanceMethods
      include Memery

      def bind(target_or_prop_name = nil, prop_name = nil)
        return properties[target_or_prop_name] if target_or_prop_name.is_a?(Symbol)

        raise ArgumentError if prop_name.nil?

        target_or_prop_name.properties[prop_name]
      end

      def assign_properties(val = {}, **props) = val.merge(props).each { send("#{_1}=", _2) }

      memoize def properties = {}
    end

    def self.extended(base)
      base.include(InstanceMethods)
    end
  end
end
