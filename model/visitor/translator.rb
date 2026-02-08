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

       def visit_bitwise_and(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} & #{right_text})"
      end

       def visit_bitwise_or(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} | #{right_text})"
      end

      def visit_bitwise_xor(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} ^ #{right_text})"
      end


      def visit_bitwise_not(node)
        child_text = node.child.visit(self)
        "~(#{child_text})"
      end

      def visit_bitwise_left_shift(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} << #{right_text})"
      end

      def visit_bitwise_right_shift(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} >> #{right_text})"
      end

      def visit_float_to_int(node)
        child_text = node.child.visit(self)
        "(#{child_text}).to_i"
      end

      def visit_int_to_float(node)
        child_text = node.child.visit(self)
        "(#{child_text}).to_f"
      end
      def visit_equals(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} == #{right_text})"
      end

      def visit_not_equals(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} != #{right_text})"
      end

      def visit_less_than(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} < #{right_text})"
      end

      def visit_less_than_or_equal(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} <= #{right_text})"
      end

      def visit_greater_than(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} > #{right_text})"
      end

      def visit_greater_than_or_equal(node)
        left_text  = node.left.visit(self)
        right_text = node.right.visit(self)
        "(#{left_text} >= #{right_text})"
      end

      def visit_rvalue(node)
        node.child.to_s
      end

      def visit_print(node)
        "print #{node.child.visit(self)}"
      end

      def visit_assignment(node)
        left_text  = node.left.to_s
        right_text = node.right.visit(self)
        "(#{left_text} = #{right_text})"
      end

       def visit_block(node)
        # Assume node.child is an array of statements
        stmts = node.child
        return "null" if !stmts.is_a?(Array) || stmts.empty?
        stmts_texts = stmts.map { |stmt| stmt.visit(self) }
        stmts_texts.join("; ")
      end
    end
  end
end
