# frozen_string_literal: true

module KO
  module Signals
    class Validator
      def initialize(arg_types)
        @arg_types = arg_types
      end

      def validate_args!(args)
        types = args.map(&:class)

        return if types.count == @arg_types.count && types_match?(types)

        raise TypeError, "expected args: #{@arg_types}. given: #{types}"
      end

      private

      def types_match?(types)
        types.each.with_index.all? do |klass, i|
          valid_types = [@arg_types[i]].flatten
          valid_types.any? { klass.ancestors.include?(_1) }
        end
      end
    end
  end
end
