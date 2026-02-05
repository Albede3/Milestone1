module Model
  module Ast
    class Not
      def initialize(child)
        @child = child
      end

      attr_reader :child

      def visit(visitor)
        visitor.visit_not(self)
      end
    end
  end
end
