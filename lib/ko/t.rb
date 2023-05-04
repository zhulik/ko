# frozen_string_literal: true

module KO
  module T
    include Dry.Types

    Float = Coercible::Float.default(0)
    Integer = Coercible::Integer.default(0)

    Bool = Bool.default(false)
    String = Coercible::String.default("")
  end
end
