# frozen_string_literal: true

module KO
  module Signals
    module InstanceMethods
      # TODO: write me!
      def respond_to_missing?(name, include_private = false); end

      def method_missing(name, *args, **params, &)
        sigs = signals.each.with_object({}) { |(_k, v), acc| acc[v.receiver_name] = v }
        super unless sigs.include?(name)

        method_name = SecureRandom.hex
        define_singleton_method(method_name, &)

        sigs[name].connect(method_name.to_sym)
      end

      private

      def signals
        @signals ||= self.class.signals.transform_values do |s|
          s.dup.tap  { _1.parent = self }
        end
      end

      def emit(name, *args) = send(name).call(*args)
    end

    module AddSignal
      def signal(name, *arg_types)
        signals[name.to_sym] = Signal.new(name, arg_types)

        d = respond_to?(:define_method) ? :define_method : :define_singleton_method
        send(d, name) { signals[name.to_sym] }
      end
    end

    class << self
      def extended(base)
        base.include(InstanceMethods)
        base.extend(AddSignal)
        base.include(AddSignal)
      end
    end

    # def method_added(name)
    #   pp([self, name])
    # end

    def inherited(child)
      super(child)
      child.signals.merge!(signals)
    end

    def signals = @signals ||= {}
  end
end
