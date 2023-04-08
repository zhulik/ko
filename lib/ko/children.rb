# frozen_string_literal: true

module KO
  class Children
    include Enumerable

    def initialize
      @store = Set.new
    end

    # TODO: use index
    def [](id) = @store.find { _1.id == id }

    def add(obj) = @store << obj

    def remove(obj)
      raise UnknownChildError unless @store.include?(obj)

      @store.delete(obj)
    end

    def inspect = to_a.inspect
    def pretty_inspect = to_a.pretty_inspect

    def each(...) = @store.each(...)
    def count(...) = @store.count(...)
  end
end
