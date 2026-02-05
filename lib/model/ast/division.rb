module Model
  module Ast
    class Division
      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_reader :left, :right

      def visit(visitor)
        visitor.visit_division(self)
      end
    end
  end
end
