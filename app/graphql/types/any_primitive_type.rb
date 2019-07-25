# frozen_string_literal: true

module Types
  class AnyPrimitiveType < Types::BaseScalar
    def self.coerce_input(value, _context)
      case value
      when String, TrueClass, FalseClass, Integer, Float then value
      else
        GraphQL::ExecutionError.new("Invalid value type: #{value.class.name}")
      end
    end

    def self.coerce_result(value, _context)
      case value
      when String, TrueClass, FalseClass, Integer, Float then value
      else
        GraphQL::ExecutionError.new("Invalid value type: #{value.class.name}")
      end
    end
  end
end
