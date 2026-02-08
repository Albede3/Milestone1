module Model
  module Ast
    module Expr
      class Addition
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_addition(self)
        end
      end

      class Subtraction
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_subtraction(self)
        end
      end

      class Multiplication
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_multiplication(self)
        end
      end

      class Division
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_division(self)
        end
      end

      class Modulo
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_modulo(self)
        end
      end

      class Exponentiation
        def initialize(left, right)
          @left = left
          @right = right
        end
        attr_reader :left, :right
        def visit(visitor)
          visitor.visit_exponentiation(self)
        end
      end

      class Negation
        def initialize(child)
          @child = child
        end
        attr_reader :child
        def visit(visitor)
          visitor.visit_negation(self)
        end
      end
    end
  end
end
