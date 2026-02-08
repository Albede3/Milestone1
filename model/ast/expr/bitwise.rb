module Model
  module Ast
    module Bitwise
      class BitwiseAnd
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_bitwise_and(self)
        end
      end

      class BitwiseOr
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_bitwise_or(self)
        end
      end

      class BitwiseXor
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_bitwise_or(self)
        end
      end

      class BitwiseNot
        def initialize(child)
          @child = child
        end
        attr_reader :child
        def visit(visitor)
          visitor.visit_bitwise_not(self)
        end
      end

      class BitwiseLeftShift
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_bitwise_or(self)
        end
      end

      class BitwiseRightShift
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_bitwise_or(self)
        end
      end
    end
  end
end
