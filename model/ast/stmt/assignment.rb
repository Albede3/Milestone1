module Model
  module Ast
    module Stmt
      class Assignment
        attr_reader :left, :right
        def initialize(left, right)
          @left = left
          @right = right
        end
        def visit(visitor)
          visitor.visit_assignment(self)
        end
      end
    end
  end
end
