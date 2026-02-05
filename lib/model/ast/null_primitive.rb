module Model
  module Ast
    class NullPrimitive
      def initialize
        @value = nil
      end

      attr_reader :value

      def visit(visitor)
        visitor.visit_null_primitive(self)
      end
    end
  end
end
