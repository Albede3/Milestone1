# lib/model/visitor/translator.rb
module Model
  module Visitor
    class Translator
      def visit_integer_primitive(node)
        node.value.to_s
      end

      def visit_float_primitive(node)
        node.value.to_s
      end

      def visit_boolean_primitive(node)
        node.value.to_s
      end

      def visit_string_primitive(node)
        "\"#{node.value}\""
      end

      def visit_null_primitive(node)
        "null"
      end

      def visit_addition(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} + #{right_text})"
      end

      def visit_subtraction(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} - #{right_text})"
      end

      def visit_multiplication(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} * #{right_text})"
      end

      def visit_division(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} / #{right_text})"
      end

      def visit_modulo(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} % #{right_text})"
      end

      def visit_exponentiation(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} ** #{right_text})"
      end

      def visit_negation(node)
        child_text = node.child.visit(self)
        "-(#{child_text})"
      end


      def visit_logical_and(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} && #{right_text})"
      end

      def visit_logical_or(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} || #{right_text})"
      end

      def visit_logical_not(node)
        child_text = node.child.visit(self)
        "!(#{child_text})"
      end
    end
  end
end
