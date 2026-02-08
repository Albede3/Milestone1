module Model
  module Ast
    module Stmt
      class Block
        def initialize(child)
          @child = child
        end
        attr_reader :child
        def visit(visitor)
          visitor.visit_block(self)
        end
      end
    end
  end
end
