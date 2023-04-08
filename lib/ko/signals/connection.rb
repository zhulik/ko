# frozen_string_literal: true

module KO
  module Signals
    class Connection
      attr_reader :callable, :mode, :signal

      def initialize(callable, signal, mode:, one_shot:)
        Validator.new(signal).validate_callable_type!(callable)

        @callable = callable
        @signal = signal
        @mode = mode
        @one_shot = one_shot
      end

      def one_shot? = @one_shot

      def call(*args, force_direct: false) # rubocop:disable Lint/UnusedMethodArgument
        return @callable.call(*args) if @callable.is_a?(Method) || @callable.is_a?(Signal)

        @callable.send(signal.receiver_name, *args)
      rescue StandardError => e
        warn(e)
      end

      def disconnect
        @signal.disconnect(@callable)
      end
    end
  end
end
