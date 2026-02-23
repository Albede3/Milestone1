require_relative "model/errors"
require_relative "model/runtime"

require_relative "model/ast/primitives"

require_relative "model/ast/expr/arithmetic"
require_relative "model/ast/expr/logical"
require_relative "model/ast/expr/bitwise"
require_relative "model/ast/expr/relational"
require_relative "model/ast/expr/cast"
require_relative "model/ast/rvalue"
require_relative "model/ast/stmt/print"
require_relative "model/ast/stmt/assignment"
require_relative "model/ast/stmt/block"

require_relative "model/visitor/translator"
require_relative "model/visitor/evaluator"

include Model

# === Arithmetic: (7 * 4 + 3) % 12 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::Modulo.new(
    Ast::Expr::Addition.new(
      Ast::Expr::Multiplication.new(Ast::IntegerPrimitive.new(7), Ast::IntegerPrimitive.new(4)),
      Ast::IntegerPrimitive.new(3)
    ),
    Ast::IntegerPrimitive.new(12)
  )

puts "\n=== Arithmetic: (7 * 4 + 3) % 12 ==="
puts "Translated: #{tree.visit(translator)}"
evaluated = tree.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Arithmetic negation and rvalues: a * b ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("a", Ast::IntegerPrimitive.new(6)),
    Ast::Stmt::Assignment.new("b", Ast::IntegerPrimitive.new(7)),
    Ast::Stmt::Print.new(
      Ast::Expr::Multiplication.new(Ast::Rvalue.new("a"), Ast::Rvalue.new("b"))
    )
  ])

puts "\n=== Arithmetic negation and rvalues: a * b ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Rvalue lookup and shift: i << 3 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("i", Ast::IntegerPrimitive.new(5)),
    Ast::Stmt::Print.new(
      Ast::Bitwise::BitwiseLeftShift.new(Ast::Rvalue.new("i"), Ast::IntegerPrimitive.new(3))
    )
  ])

puts "\n=== Rvalue lookup and shift: i << 3 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Rvalue lookup and comparison: j == j + 0 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("j", Ast::IntegerPrimitive.new(42)),
    Ast::Stmt::Print.new(
      Ast::Expr::Equals.new(
        Ast::Rvalue.new("j"),
        Ast::Expr::Addition.new(Ast::Rvalue.new("j"), Ast::IntegerPrimitive.new(0))
      )
    )
  ])

puts "\n=== Rvalue lookup and comparison: j == j + 0 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Logic and comparison: !(3.3 > 3.2) ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::LogicalNot.new(
    Ast::Expr::GreaterThan.new(
      Ast::FloatPrimitive.new(3.3),
      Ast::FloatPrimitive.new(3.2)
    )
  )

puts "\n=== Logic and comparison: !(3.3 > 3.2) ==="
puts "Translated: #{tree.visit(translator)}"
evaluated = tree.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Double negation: --(6 * 8) ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::Negation.new(
    Ast::Expr::Negation.new(
      Ast::Expr::Multiplication.new(Ast::IntegerPrimitive.new(6), Ast::IntegerPrimitive.new(8))
    )
  )

puts "\n=== Double negation: --(6 * 8) ==="
puts "Translated: #{tree.visit(translator)}"
evaluated = tree.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Bitwise operations: ~5 | ~8 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Bitwise::BitwiseOr.new(
    Ast::Bitwise::BitwiseNot.new(Ast::IntegerPrimitive.new(5)),
    Ast::Bitwise::BitwiseNot.new(Ast::IntegerPrimitive.new(8))
  )

puts "\n=== Bitwise operations: ~5 | ~8 ==="
puts "Translated: #{tree.visit(translator)}"
evaluated = tree.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Casting: float(7) / 2 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::Division.new(
    Ast::Expr::IntToFloat.new(Ast::IntegerPrimitive.new(7)),
    Ast::IntegerPrimitive.new(2)
  )

puts "\n=== Casting: float(7) / 2 ==="
puts "Translated: #{tree.visit(translator)}"
evaluated = tree.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# === Assignment: n = 9 & 3 ===
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("n",
      Ast::Bitwise::BitwiseAnd.new(Ast::IntegerPrimitive.new(9), Ast::IntegerPrimitive.new(3))
    ),
    Ast::Stmt::Print.new(Ast::Rvalue.new("n"))
  ])

puts "\n=== Assignment: n = 9 & 3 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# -----------------------------------------------------------------------------
# Multiple-statement programs
# -----------------------------------------------------------------------------

# x = 17
# print x
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("x", Ast::IntegerPrimitive.new(17)),
    Ast::Stmt::Print.new(Ast::Rvalue.new("x"))
  ])

puts "\n=== Program 1 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# count = 6 << 1
# delta = 3
# count = count + delta
# print count
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("count",
      Ast::Bitwise::BitwiseLeftShift.new(Ast::IntegerPrimitive.new(6), Ast::IntegerPrimitive.new(1))
    ),
    Ast::Stmt::Assignment.new("delta", Ast::IntegerPrimitive.new(3)),
    Ast::Stmt::Assignment.new("count",
      Ast::Expr::Addition.new(Ast::Rvalue.new("count"), Ast::Rvalue.new("delta"))
    ),
    Ast::Stmt::Print.new(Ast::Rvalue.new("count"))
  ])

puts "\n=== Program 2 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

# n = 18
# print n <= 18
# print 13 <= n && n <= 16
# print -(n ** 2)
translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

prog =
  Ast::Stmt::Block.new([
    Ast::Stmt::Assignment.new("n", Ast::IntegerPrimitive.new(18)),

    Ast::Stmt::Print.new(
      Ast::Expr::LessThanOrEqual.new(Ast::Rvalue.new("n"), Ast::IntegerPrimitive.new(18))
    ),

    Ast::Stmt::Print.new(
      Ast::Expr::LogicalAnd.new(
        Ast::Expr::LessThanOrEqual.new(Ast::IntegerPrimitive.new(13), Ast::Rvalue.new("n")),
        Ast::Expr::LessThanOrEqual.new(Ast::Rvalue.new("n"), Ast::IntegerPrimitive.new(16))
      )
    ),

    Ast::Stmt::Print.new(
      Ast::Expr::Negation.new(
        Ast::Expr::Exponentiation.new(Ast::Rvalue.new("n"), Ast::IntegerPrimitive.new(2))
      )
    )
  ])

puts "\n=== Program 3 ==="
puts "Translated:\n#{prog.visit(translator)}"
evaluated = prog.visit(evaluator)
puts "Evaluated:  #{evaluated.visit(translator)}"

puts "\n=== Type Error: 7.5 << 2 ==="

translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Bitwise::BitwiseLeftShift.new(
    Ast::FloatPrimitive.new(7.5),
    Ast::IntegerPrimitive.new(2)
  )

puts "Translated: #{tree.visit(translator)}"

begin
  value = tree.visit(evaluator)
  puts "Evaluated:  #{value.visit(translator)}"
rescue => e
  puts "Error: #{e.class} - #{e.message}"
end

puts "\n=== Type Error: true >= 10 ==="

translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::GreaterThanOrEqual.new(
    Ast::BooleanPrimitive.new(true),
    Ast::IntegerPrimitive.new(10)
  )

puts "Translated: #{tree.visit(translator)}"

begin
  value = tree.visit(evaluator)
  puts "Evaluated:  #{value.visit(translator)}"
rescue => e
  puts "Error: #{e.class} - #{e.message}"
end

puts "\n=== Type Error: \"fooo\" / 3 ==="

translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::Division.new(
    Ast::StringPrimitive.new("fooo"),
    Ast::IntegerPrimitive.new(3)
  )

puts "Translated: #{tree.visit(translator)}"

begin
  value = tree.visit(evaluator)
  puts "Evaluated:  #{value.visit(translator)}"
rescue => e
  puts "Error: #{e.class} - #{e.message}"
end

puts "\n=== Type Error: 5 && 3 ==="

translator = Visitor::Translator.new
runtime    = Runtime.new
evaluator  = Visitor::Evaluator.new(runtime)

tree =
  Ast::Expr::LogicalAnd.new(
    Ast::IntegerPrimitive.new(5),
    Ast::IntegerPrimitive.new(3)
  )

puts "Translated: #{tree.visit(translator)}"

begin
  value = tree.visit(evaluator)
  puts "Evaluated:  #{value.visit(translator)}"
rescue => e
  puts "Error: #{e.class} - #{e.message}"
end