module Model
  module Ast
    module Expr
      class FloatToInt
        attr_reader :child
        def initialize(child)
          @child = child
        end
        def visit(visitor)
          visitor.visit_float_to_int(self)
        end
      end

      class IntToFloat
        attr_reader :child
        def initialize(child)
          @child = child
        end
        def visit(visitor)
          visitor.visit_int_to_float(self)
        end
      end
    end
  end
end
