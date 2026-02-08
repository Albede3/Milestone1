module Model
  module Ast
    module Stmt
      class Print
        attr_reader :child

        def initialize(child)
          @child = child
        end

        def visit(visitor)
          visitor.visit_print(self)
        end
      end
    end
  end
end
