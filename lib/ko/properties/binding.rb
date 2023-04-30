# frozen_string_literal: true

module KO
  module Properties
    class Binding
      def initialize(target, property)
        @target = target
        @property = property
        @value = @target.send(@property)
        @signal = @target.send(:"#{@property}_changed")
      end

      def apply(target, property)
        setter = target.method(:"#{property}=")
        setter.call(@value)
        @signal.connect(setter)
      end
    end
  end
end
