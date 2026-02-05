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
