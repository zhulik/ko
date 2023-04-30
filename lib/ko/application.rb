# frozen_string_literal: true

module KO
  class Application < Object
    # rubocop:disable Style/GlobalVars
    class << self
      def instance = $_KO_APP
    end

    def initialize(id: nil, parent: nil, &)
      raise AlreadyIitialized if $_KO_APP

      begin
        super(id: id || "app", parent:)
      rescue InvalidParent
        @parent = nil
        instance_exec(&) if block_given?
        ready.emit
      end

      $_KO_APP = self
    end
    # rubocop:enable Style/GlobalVars

    def parent=(*)
      raise KO::InvalidParent, "KO::Application cannot have a parent"
    end
  end
end
