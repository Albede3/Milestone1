module Model
  module Ast
    class Modulo
      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_reader :left, :right

      def visit(visitor)
        visitor.visit_modulo(self)
      end
    end
  end
end
