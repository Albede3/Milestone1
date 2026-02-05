module Model
  module Ast
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
  end
end
