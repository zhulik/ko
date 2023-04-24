# frozen_string_literal: true

module KO
  module Signals
    class Signal
      attr_reader :name, :arg_types, :connections, :parent

      def initialize(name, arg_types)
        @name = name
        @arg_types = arg_types

        @validator = Validator.new(self)
        @connections = {}
      end

      def parent=(obj)
        raise KO::SignalParentOverrideError unless @parent.nil?
        raise KO::InvalidParent unless obj.is_a?(KO::Object)

        @parent = obj
      end

      def dup = self.class.new(name, arg_types)

      def receiver_name = "on_#{name}".to_sym

      def connect(receiver, mode: :direct, one_shot: false)
        receiver = parent.method(receiver) if receiver.is_a?(Symbol)
        @validator.validate_receiver!(receiver)

        raise "ALREADY CONNECTED" if @connections.include?(receiver)

        Connection.new(receiver, self, mode:, one_shot:).tap { @connections[receiver] = _1 }
      end

      def disconnect(receiver)
        raise ArgumentError, "given receiver is not connected to this signal" if @connections.delete(receiver).nil?
      end

      def emit(*args)
        @validator.validate_args!(args)
        notify_subscribers(args)
      end

      def inspect = "#<#{self.class}@#{object_id}[#{name.inspect}] connections=#{@connections.count}>"

      def call(...) = emit(...)

      def notify_subscribers(args)
        @connections.values.shuffle.each do |connection|
          connection.call(*args)
        ensure
          connection.disconnect if connection.one_shot?
        end
      end
    end
  end
end
