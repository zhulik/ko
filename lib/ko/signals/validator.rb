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
        receiver = validate_receiver_type!(receiver)
        validate_signal_arity!(receiver) if receiver.is_a?(Signal)
      end

      def validate_receiver_type!(receiver)
        if receiver.is_a?(Signal) ||
           (receiver.is_a?(Method) && receiver.receiver.is_a?(KO::Object)) ||
           (receiver.is_a?(KO::Object) && receiver.respond_to?(@signal.receiver_name))
          return receiver
        end

        raise ArgumentError, "receiver must be a Signal or a KO::Object's method, given: #{receiver.class}"
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
