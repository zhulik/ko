# frozen_string_literal: true

module KO
  class Children
    include Enumerable

    def initialize
      @store = {}
    end

    # TODO: use index
    def [](id) = @store.find { _1.id == id }

    def add(obj) = @store[obj] = obj

    def remove(obj)
      raise UnknownChildError unless @store.include?(obj)

      @store.delete(obj)
    end

    def to_a = @store.keys

    def inspect = to_a.inspect
    def pretty_inspect = to_a.pretty_inspect

    def each(...) = @store.each_key(...)
    def count(...) = @store.count(...)
  end
end
