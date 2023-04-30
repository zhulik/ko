# frozen_string_literal: true

require_relative "ko/version"

require "zeitwerk"
require "binding_of_caller"
require "rutie"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "ko" => "KO"
)
loader.setup

module KO
  class Error < StandardError; end

  class InvalidParent < Error
    def initialize(msg = "only KO::Object can be a parent for KO::Object")
      super(msg)
    end
  end

  class AlreadyIitialized < Error
    def initialize
      super("KO is already initialized: only one instance of KO::Application must exist")
    end
  end

  class UnknownChildError < Error; end
  class SignalParentOverrideError < Error; end
end

loader.eager_load

Rutie.new(:ko).init("Init_ko", __dir__)
