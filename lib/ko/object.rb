# frozen_string_literal: true

module KO
  class Object
    extend Signals
    extend Properties

    class << self
      def [](id = nil, &)
        new(id:).tap do |obj|
          obj.instance_exec(&) if block_given?
          obj.ready.emit
        end
      end
    end

    attr_reader :id, :parent

    signal :ready

    def initialize(id: nil, parent: nil)
      @id = id
      self.parent = parent || find_parent
    end

    def children = @children ||= Children.new

    def parent=(obj)
      raise KO::InvalidParent unless can_be_parent?(obj)

      parent&.remove_child(self)
      @parent = obj
      parent.add_child(self)
    end

    def add_child(obj)
      obj.parent = self if obj.parent != self

      children.add(obj)
    end

    def remove_child(obj) = children.remove(obj)

    def [](id) = children[id]

    def app = KO::Application.instance

    def inspect
      id_str = id.nil? ? "" : "[#{id.inspect}]"
      "#<#{self.class}#{id_str} signals=#{signals.count} properties=0 children=#{children.count}>"
    end

    private

    def find_parent
      binding.callers[2..].each do |caller|
        obj = caller.receiver
        return obj if can_be_parent?(obj)
      end
      raise KO::InvalidParent
    end

    def can_be_parent?(obj)
      obj.is_a?(KO::Object) && obj != self
    end
  end
end
