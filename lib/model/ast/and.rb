module Model
  module Ast
    class And
      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_reader :left, :right

      def visit(visitor)
        visitor.visit_and(self)
      end
    end
  end
end
