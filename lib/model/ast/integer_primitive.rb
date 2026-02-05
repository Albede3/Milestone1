module Model
  module Ast
    class IntegerPrimitive
      def initialize(value)
        unless value.is_a?(Integer)
          raise ArgumentError, "IntegerPrimitive expects Integer, got #{value.class}"
        end
        @value = value
      end

      attr_reader :value

      def visit(visitor)
        visitor.visit_integer_primitive(self)
      end
    end
  end
end
