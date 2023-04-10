# frozen_string_literal: true

module KO
  module Signals
    class Connection
      attr_reader :receiver, :mode, :signal

      def initialize(receiver, signal, mode:, one_shot:)
        Validator.new(signal).validate_receiver_type!(receiver)

        @receiver = receiver
        @signal = signal
        @mode = mode
        @one_shot = one_shot
      end

      def one_shot? = @one_shot

      def call(*args, force_direct: false) # rubocop:disable Lint/UnusedMethodArgument
        return @receiver.call(*args) if @receiver.is_a?(Method) || @receiver.is_a?(Signal)

        @receiver.send(signal.receiver_name, *args)
      rescue StandardError => e
        warn(e)
      end

      def disconnect
        @signal.disconnect(@receiver)
      end
    end
  end
end
