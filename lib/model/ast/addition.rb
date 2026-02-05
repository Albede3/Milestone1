module Model
  module Ast
    class Addition
      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_reader :left, :right

      def visit(visitor)
        visitor.visit_addition(self)
      end
    end
  end
end
