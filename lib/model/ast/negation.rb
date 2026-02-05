module Model
  module Ast
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
