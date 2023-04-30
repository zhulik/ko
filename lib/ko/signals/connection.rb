# frozen_string_literal: true

module KO
  module Signals
    class Connection
      attr_reader :receiver

      def initialize(receiver, one_shot: false)
        @receiver = receiver
        @one_shot = one_shot
      end

      def one_shot? = @one_shot

      def call(*args)
        @receiver.call(*args)
      rescue StandardError => e
        warn(e)
      end
    end
  end
end
