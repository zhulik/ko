# frozen_string_literal: true

module KO
  module Properties
    class Property
      attr_reader :value

      def initialize(name, type, signal, &block)
        @name = name
        @type = type

        @signal = signal

        self.value = block&.call || type[]
      end

      def bind(target, property)
        setter = target.method(:"#{property}=")
        setter.call(@value)
        @signal.connect(setter)
      end

      def value=(val)
        val = @type[val]

        @signal.emit(@value = val) if val != @value
      rescue StandardError
        raise TypeError, "#{@name} expected: #{@type}, given: #{val.inspect}"
      end
    end
  end
end
