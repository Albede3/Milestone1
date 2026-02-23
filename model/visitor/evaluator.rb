require_relative "../errors"

module Model
  module Visitor
    class Evaluator
      def initialize(runtime)
        @runtime = runtime
      end

      def numeric?(v)
      v.is_a?(Model::Ast::IntegerPrimitive) || v.is_a?(Model::Ast::FloatPrimitive)
      end

      def to_f(v)
        v.is_a?(Model::Ast::FloatPrimitive) ? v.value : v.value.to_f
      end

      def visit_integer_primitive(node)
        node end
      def visit_float_primitive(node)
        node end
      def visit_boolean_primitive(node)
        node end
      def visit_string_primitive(node)
        node end
      def visit_null_primitive(node)
        node end

      def visit_addition(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Addition left operand must be numeric, got #{primitive_type_name(left_val)}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Addition right operand must be numeric, got #{primitive_type_name(right_val)}"
        end

        if left_val.is_a?(Model::Ast::FloatPrimitive) || right_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(to_f(left_val) + to_f(right_val))
        else
          Model::Ast::IntegerPrimitive.new(left_val.value + right_val.value)
        end
      end

      def visit_subtraction(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Subtraction left operand must be numeric, got #{primitive_type_name(left_val)}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Subtraction right operand must be numeric, got #{primitive_type_name(right_val)}"
        end

        if left_val.is_a?(Model::Ast::FloatPrimitive) || right_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(to_f(left_val) - to_f(right_val))
        else
          Model::Ast::IntegerPrimitive.new(left_val.value - right_val.value)
        end
      end

      def visit_multiplication(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Multiplication left operand must be numeric, got #{primitive_type_name(left_val)}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Multiplication right operand must be numeric, got #{primitive_type_name(right_val)}"
        end

        if left_val.is_a?(Model::Ast::FloatPrimitive) || right_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(to_f(left_val) * to_f(right_val))
        else
          Model::Ast::IntegerPrimitive.new(left_val.value * right_val.value)
        end
      end

      def visit_division(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Division left operand must be numeric, got #{primitive_type_name(left_val)}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Division right operand must be numeric, got #{primitive_type_name(right_val)}"
        end
        if (right_val.is_a?(Model::Ast::FloatPrimitive) && right_val.value == 0.0) || (right_val.is_a?(Model::Ast::IntegerPrimitive) && right_val.value == 0)
          raise ZeroDivisionError, "Division by zero"
        end

        if left_val.is_a?(Model::Ast::FloatPrimitive) || right_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(to_f(left_val) / to_f(right_val))
        else
          Model::Ast::IntegerPrimitive.new(left_val.value / right_val.value)
        end
      end

      def visit_modulo(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Modulo left operand must be numeric, got #{primitive_type_name(left_val)}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Modulo right operand must be numeric, got #{primitive_type_name(right_val)}"
        end
        if (right_val.is_a?(Model::Ast::FloatPrimitive) && right_val.value == 0.0) || (right_val.is_a?(Model::Ast::IntegerPrimitive) && right_val.value == 0)
          raise ZeroDivisionError, "Modulo by zero"
        end

        if left_val.is_a?(Model::Ast::FloatPrimitive) || right_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(to_f(left_val) % to_f(right_val))
        else
          Model::Ast::IntegerPrimitive.new(left_val.value % right_val.value)
        end
      end

      def visit_exponentiation(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless numeric?(left_val)
          raise Model::TypeError, "Exponentiation left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Exponentiation right operand must be numeric, got #{right_val.class}"
        end

        if left_val.is_a?(Model::Ast::IntegerPrimitive) && right_val.is_a?(Model::Ast::IntegerPrimitive)
          if right_val.value < 0
            raise ArgumentError, "Negative exponent not supported for IntegerPrimitive"
          end
          Model::Ast::IntegerPrimitive.new(left_val.value ** right_val.value)
        else
          Model::Ast::FloatPrimitive.new(to_f(left_val) ** to_f(right_val))
        end
      end

      def visit_negation(node)
        child_val = node.child.visit(self)

        unless numeric?(child_val)
          raise Model::TypeError, "Negation operand must be numeric, got #{child_val.class}"
        end

        if child_val.is_a?(Model::Ast::FloatPrimitive)
          Model::Ast::FloatPrimitive.new(-to_f(child_val))
        else
          Model::Ast::IntegerPrimitive.new(-child_val.value)
        end
      end

      def visit_logical_and(node)
        left_val = node.left.visit(self)
        unless left_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "LogicalAnd left operand must be boolean, got #{primitive_type_name(left_val)}"
        end
        return Model::Ast::BooleanPrimitive.new(false) unless left_val.value
        right_val = node.right.visit(self)
        unless right_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "LogicalAnd right operand must be boolean, got #{primitive_type_name(right_val)}"
        end
        Model::Ast::BooleanPrimitive.new(right_val.value)
      end

      def visit_logical_or(node)
        left_val = node.left.visit(self)
        unless left_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "LogicalOr left operand must be boolean, got #{left_val.class}"
        end
        return Model::Ast::BooleanPrimitive.new(true) if left_val.value
        right_val = node.right.visit(self)
        unless right_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "LogicalOr right operand must be boolean, got #{primitive_type_name(right_val)}"
        end
        Model::Ast::BooleanPrimitive.new(right_val.value)
      end
      def visit_logical_not(node)
        child_val = node.child.visit(self)
        unless child_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "LogicalNot operand must be boolean, got #{child_val.class}"
        end
        Model::Ast::BooleanPrimitive.new(!child_val.value)
      end

      def visit_bitwise_and(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless left_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{left_val.class}"
        end
        unless right_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise right operand must be an integer, got #{right_val.class}"
        end
        Model::Ast::IntegerPrimitive.new(left_val.value & right_val.value)
      end

      def visit_bitwise_or(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless left_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{left_val.class}"
        end
        unless right_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise right operand must be an integer, got #{right_val.class}"
        end
        Model::Ast::IntegerPrimitive.new(left_val.value | right_val.value)
      end

      def visit_bitwise_xor(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless left_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{left_val.class}"
        end
        unless right_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise right operand must be an integer, got #{right_val.class}"
        end
        Model::Ast::IntegerPrimitive.new(left_val.value ^ right_val.value)
      end

      def visit_bitwise_not(node)
        child_val = node.child.visit(self)

        unless child_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{child_val.class}"
        end
        Model::Ast::IntegerPrimitive.new(~child_val.value)
      end

      def visit_bitwise_left_shift(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless left_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{primitive_type_name(left_val)}"
        end
        unless right_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise right operand must be an integer, got #{primitive_type_name(right_val)}"
        end
        Model::Ast::IntegerPrimitive.new(left_val.value << right_val.value)
      end

      def visit_bitwise_right_shift(node)
        left_val  = node.left.visit(self)
        right_val = node.right.visit(self)

        unless left_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise left operand must be an integer, got #{primitive_type_name(left_val)}"
        end
        unless right_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "Bitwise right operand must be an integer, got #{primitive_type_name(right_val)}"
        end
        Model::Ast::FloatPrimitive.new(left_val.value >> right_val.value)
      end
      def visit_equals(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        Model::Ast::BooleanPrimitive.new(left_val.value == right_val.value)
      end

      def visit_not_equals(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        Model::Ast::BooleanPrimitive.new(left_val.value != right_val.value)
      end

      def visit_less_than(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        unless numeric?(left_val) && numeric?(right_val)
          raise Model::TypeError, "LessThan operands must be numeric"
        end
        Model::Ast::BooleanPrimitive.new(to_f(left_val) < to_f(right_val))
      end

      def visit_less_than_or_equal(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        unless numeric?(left_val) && numeric?(right_val)
          raise Model::TypeError, "LessThanOrEqual operands must be numeric"
        end
        Model::Ast::BooleanPrimitive.new(to_f(left_val) <= to_f(right_val))
      end

      def visit_greater_than(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        unless numeric?(left_val) && numeric?(right_val)
          raise Model::TypeError, "GreaterThan operands must be numeric"
        end
        Model::Ast::BooleanPrimitive.new(to_f(left_val) > to_f(right_val))
      end

      def visit_greater_than_or_equal(node)
        left_val = node.left.visit(self)
        right_val = node.right.visit(self)
        unless numeric?(left_val) && numeric?(right_val)
          raise Model::TypeError, "GreaterThanOrEqual operands must be numeric"
        end
        Model::Ast::BooleanPrimitive.new(to_f(left_val) >= to_f(right_val))
      end

      def visit_float_to_int(node)
        child_val = node.child.visit(self)
        unless child_val.is_a?(Model::Ast::FloatPrimitive)
          raise Model::TypeError, "FloatToInt operand must be a float, got #{child_val.class}"
        end
        Model::Ast::IntegerPrimitive.new(child_val.value.to_i)
      end

      def visit_int_to_float(node)
        child_val = node.child.visit(self)
        unless child_val.is_a?(Model::Ast::IntegerPrimitive)
          raise Model::TypeError, "IntToFloat operand must be an integer, got #{child_val.class}"
        end
        Model::Ast::FloatPrimitive.new(child_val.value.to_f)
      end

      def visit_rvalue(node)
        var_name = node.child
        unless @runtime.has?(var_name)
          raise NameError, "Undefined variable: #{var_name}"
        end
        @runtime.get(var_name)
      end

      def visit_print(node)
        val = node.child.visit(self)
        if val.respond_to?(:value)
          puts val.value.to_s
        else
          puts val.to_s
        end
        Model::Ast::NullPrimitive.new
      end

      def visit_assignment(node)
        name = node.left
        value = node.right.visit(self)
        @runtime.set(name, value)
        value
      end

      def visit_block(node)
        stmts = node.child
        unless stmts.is_a?(Array)
          raise ArgumentError, "Block expects an array of statements"
        end
        result = nil
        stmts.each { |stmt| result = stmt.visit(self) }
        result.nil? ? Model::Ast::NullPrimitive.new : result
      end

      def primitive_type_name(val)
        case val
        when Model::Ast::IntegerPrimitive then 'integer'
        when Model::Ast::FloatPrimitive then 'float'
        when Model::Ast::BooleanPrimitive then 'boolean'
        when Model::Ast::StringPrimitive then 'string'
        when Model::Ast::NullPrimitive then 'null'
        else val.class.to_s
        end
      end
    end
  end
end
