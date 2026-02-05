module Model
  module Ast
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
  end
end
