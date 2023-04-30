# frozen_string_literal: true

module KO
  module Signals
    class Validator
      def initialize(arg_types)
        @arg_types = arg_types
      end

      def validate_args!(args)
        types = args.map(&:class)

        return if types.count == @arg_types.count && types_match?(types)

        raise TypeError, "expected args: #{@arg_types}. given: #{types}"
      end

      def validate_receiver!(receiver)
        unless receiver.respond_to?(:call)
          raise ArgumentError,
                "receiver must respond to :call. Given: #{receiver.inspect}"
        end

        validate_signal_arity!(receiver) if receiver.is_a?(Signal)
      end

      private

      def types_match?(types)
        types.each.with_index.all? do |klass, i|
          valid_types = [@arg_types[i]].flatten
          valid_types.any? { klass.ancestors.include?(_1) }
        end
      end

      def validate_signal_arity!(signal)
        return if signal.arg_types == @arg_types

        raise TypeError,
              "target signal must have same type signature. Expected: #{@arg_types}. given: #{signal.arg_types}"
      end
    end
  end
end
