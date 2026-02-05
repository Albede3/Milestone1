module Model
  module Ast
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
  end
end
