# frozen_string_literal: true

module KO
  module Signals
    include Memery

    module InstanceMethods
      include Memery
      # TODO: write me!
      def respond_to_missing?(name, include_private = false); end

      def method_missing(name, *args, **params, &)
        _, signal = signals.find { _2.receiver_name == name } || super

        signal.connect(&)
      end

      memoize def signals = self.class.signals.transform_values(&:dup)
    end

    module AddSignal
      def signal(name, *arg_types)
        s = Signal.new(name, arg_types)
        signals[name.to_sym] = s

        d = respond_to?(:define_method) ? :define_method : :define_singleton_method
        send(d, name) { signals[name.to_sym] }
        s
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

    memoize def signals = {}
  end
end
