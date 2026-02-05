module Model
  module Ast
    class Or
      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_reader :left, :right

      def visit(visitor)
        visitor.visit_or(self)
      end
    end
  end
end
