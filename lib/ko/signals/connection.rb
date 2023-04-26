# frozen_string_literal: true

module KO
  module Signals
    class Connection
      attr_reader :receiver, :mode, :signal

      def initialize(receiver, signal, mode:, one_shot:)
        @receiver = receiver
        @signal = signal
        @mode = mode
        @one_shot = one_shot
      end

      def one_shot? = @one_shot

      def call(*args, force_direct: false) # rubocop:disable Lint/UnusedMethodArgument
        @receiver.call(*args)
      rescue StandardError => e
        warn(e)
      ensure
        disconnect if one_shot?
      end

      def disconnect = @signal.disconnect(@receiver)
    end
  end
end
