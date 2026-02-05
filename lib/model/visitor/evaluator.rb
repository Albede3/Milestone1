# lib/model/visitor/evaluator.rb
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
        node
      end
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
          raise Model::TypeError, "Addition left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Addition right operand must be numeric, got #{right_val.class}"
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
          raise Model::TypeError, "Subtraction left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Subtraction right operand must be numeric, got #{right_val.class}"
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
          raise Model::TypeError, "Multiplication left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Multiplication right operand must be numeric, got #{right_val.class}"
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
          raise Model::TypeError, "Division left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Division right operand must be numeric, got #{right_val.class}"
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
          raise Model::TypeError, "Modulo left operand must be numeric, got #{left_val.class}"
        end
        unless numeric?(right_val)
          raise Model::TypeError, "Modulo right operand must be numeric, got #{right_val.class}"
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

      def visit_and(node)
        left_val = node.left.visit(self)
        unless left_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "AND left operand must be boolean, got #{left_val.class}"
        end
        # Short-circuit: if left is false, return false without evaluating right
        return Model::Ast::BooleanPrimitive.new(false) unless left_val.value

        right_val = node.right.visit(self)
        unless right_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "AND right operand must be boolean, got #{right_val.class}"
        end
        Model::Ast::BooleanPrimitive.new(right_val.value)
      end

      def visit_or(node)
        left_val = node.left.visit(self)
        unless left_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "OR left operand must be boolean, got #{left_val.class}"
        end
        # Short-circuit: if left is true, return true without evaluating right
        return Model::Ast::BooleanPrimitive.new(true) if left_val.value

        right_val = node.right.visit(self)
        unless right_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "OR right operand must be boolean, got #{right_val.class}"
        end
        Model::Ast::BooleanPrimitive.new(right_val.value)
      end

      def visit_not(node)
        child_val = node.child.visit(self)

        unless child_val.is_a?(Model::Ast::BooleanPrimitive)
          raise Model::TypeError, "NOT operand must be boolean, got #{child_val.class}"
        end
        Model::Ast::BooleanPrimitive.new(!child_val.value)
      end
    end
  end
end
