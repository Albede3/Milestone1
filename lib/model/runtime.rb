# lib/model/runtime.rb
module Model
  class Runtime
    def initialize
      @vars = {}
    end

    def get(name)
      if @vars.key?(name)
        @vars[name]
      else
        raise UndefinedVariableError, "Undefined variable '#{name}'"
      end
    end

    def set(name, value_node)
      @vars[name] = value_node
    end
  end
end
