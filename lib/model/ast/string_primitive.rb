module Model
  module Ast
    class StringPrimitive
      def initialize(value)
        unless value.is_a?(String)
          raise ArgumentError, "StringPrimitive expects String, got #{value.class}"
        end
        @value = value
      end

      attr_reader :value

      def visit(visitor)
        visitor.visit_string_primitive(self)
      end
    end
  end
end
