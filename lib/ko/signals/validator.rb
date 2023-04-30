# frozen_string_literal: true

module KO
  module Signals
    class Validator
      def initialize(signal)
        @signal = signal
      end

      def validate_args!(args)
        types = args.map(&:class)

        return if types.count == @signal.arg_types.count && types_match?(types)

        raise KO::EmitError, "expected args: #{@signal.arg_types}. given: #{types}"
      end

      def validate_receiver!(receiver)
        validate_receiver_type!(receiver)
        validate_signal_arity!(receiver) if receiver.is_a?(Signal)
      end

      def validate_receiver_type!(receiver)
        raise ArgumentError, "receiver must respond to call. Given #{receiver.class}" unless receiver.respond_to?(:call)
      end

      private

      def types_match?(types)
        types.each.with_index.all? do |klass, i|
          valid_types = [@signal.arg_types[i]].flatten
          valid_types.any? { klass.ancestors.include?(_1) }
        end
      end

      def validate_signal_arity!(signal)
        return if signal.arg_types == @signal.arg_types

        raise ArgumentError,
              "target signal must have same type signature. Expected: #{@signal.arg_types}. given: #{signal.arg_types}"
      end
    end
  end
end
