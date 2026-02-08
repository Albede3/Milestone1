module Model
  module Ast
    class Rvalue
      attr_reader :child
      def initialize(child)
        @child = child
      end
      def visit(visitor)
        visitor.visit_rvalue(self)
      end
    end
  end
end
