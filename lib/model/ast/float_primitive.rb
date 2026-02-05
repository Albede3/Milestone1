module Model
  module Ast
    class FloatPrimitive
      def initialize(value)
        unless value.is_a?(Float)
          raise ArgumentError, "FloatPrimitive expects Float, got #{value.class}"
        end
        @value = value
      end

      attr_reader :value

      def visit(visitor)
        visitor.visit_float_primitive(self)
      end
    end
  end
end
