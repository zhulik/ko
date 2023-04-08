# frozen_string_literal: true

module KO
  class Application < Object
    # rubocop:disable Style/GlobalVars
    class << self
      def instance = $_KO_APP
    end

    def initialize(id: nil)
      begin
        super(id: id || "app")
      rescue InvalidParent
        @parent = nil
      end
      raise AlreadyIitialized if $_KO_APP

      $_KO_APP = self
    end
    # rubocop:enable Style/GlobalVars

    def parent=(_obj)
      raise KO::InvalidParent, "KO::Application cannot have a parent"
    end
  end
end
