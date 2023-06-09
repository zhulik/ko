# frozen_string_literal: true

module KO
  module Signals
    class Signal
      attr_reader :name, :arg_types, :connections

      def initialize(name, arg_types)
        @name = name
        @arg_types = arg_types

        @connections = {}
      end

      def dup = self.class.new(@name, @arg_types)

      def receiver_name = :"on_#{@name}"

      def connect(receiver = nil, one_shot: false, &block)
        receiver ||= block
        raise ArgumentError unless receiver.respond_to?(:call)

        raise "ALREADY CONNECTED" if @connections.include?(receiver)

        @connections[receiver] = Connection.new(receiver, one_shot:)
      end

      def disconnect(receiver)
        receiver = normalize_receiver(receiver)
        raise ArgumentError, "given receiver is not connected to this signal" if @connections.delete(receiver).nil?
      end

      def emit(*args)
        validate_args!(args)

        @connections.each_value do |conn|
          conn.call(*args)
          disconnect(conn.receiver) if conn.one_shot?
        end
      end

      def inspect = "#<#{self.class}@#{object_id}[#{name.inspect}] connections=#{@connections.count}>"

      def call(...) = emit(...)

      private

      def normalize_receiver(receiver)
        return if receiver.nil?
        return receiver if receiver.respond_to?(:call)
      end

      def validate_args!(args)
        return if @arg_types.count == args.count && @arg_types.zip(args).each.all? { _1.valid?(_2) }

        raise TypeError, "expected args: #{@arg_ypes}. given: #{args}"
      end
    end
  end
end
