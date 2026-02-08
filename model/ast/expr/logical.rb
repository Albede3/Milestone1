module Model
  module Ast
    module Expr
      class LogicalAnd
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_logical_and(self)
        end
      end

      class LogicalOr
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_logical_or(self)
        end
      end

      class LogicalNot
        def initialize(child)
          @child = child
        end
        attr_reader :child
        def visit(visitor)
          visitor.visit_logical_not(self)
        end
      end
    end
  end
end
