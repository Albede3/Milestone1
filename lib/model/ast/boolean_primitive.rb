module Model
  module Ast
    class BooleanPrimitive
      def initialize(value)
        unless value == true || value == false
          raise ArgumentError, "BooleanPrimitive expects true/false, got #{value.inspect}"
        end
        @value = value
      end

      attr_reader :value

      def visit(visitor)
        visitor.visit_boolean_primitive(self)
      end
    end
  end
end
