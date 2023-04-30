# frozen_string_literal: true

module KO
  module Properties
    class Property
      attr_reader :value

      def initialize(name, type, value, owner, signal)
        @name = name
        @types = [type].flatten

        @owner = owner
        @signal = owner.signals[signal]

        self.value = value.nil? && type.is_a?(Class) ? type.new : value
      end

      def bind(target, property)
        setter = target.method(:"#{property}=")
        setter.call(@value)
        @signal.connect(setter)
      end

      def value=(val)
        raise TypeError if @types.none? { val.is_a?(_1) }

        @signal.emit(@value = val) if val != @value
      end
    end
  end
end
