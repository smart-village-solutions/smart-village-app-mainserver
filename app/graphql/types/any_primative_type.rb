module Types
  class AnyPrimativeType < Types::BaseScalar
    def self.coerce_input(value, context)
      case value
      when String, TrueClass, FalseClass, Integer, Float then value
      else
        GraphQL::ExecutionError.new("Invalid value type: #{value.class.name}")
      end
    end

    def self.coerce_result(value, context)
      case value
      when String, TrueClass, FalseClass, Integer, Float then value
      else
        GraphQL::ExecutionError.new("Invalid value type: #{value.class.name}")
      end
    end
  end
end
