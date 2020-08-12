# frozen_string_literal: true

module Katarina
  module TypeGenerator
    class << self
      def generate(schema)
        [
          "type #{schema.name} = ",
          members(schema.types),
          "\n",
        ].join
      end

      private

      def members(types, level = 0)
        case types
        when Hash
          [
            "{",
            types.map { |name, type| member(name, type, level + 1) },
            "#{indent(level)}}",
          ].join("\n")
        when Array
          "#{members(types.first, level)}[]"
        when String
          number?(types) ? 'number' : types
        else
          raise "unknown type => #{types.class}: #{types}"
        end
      end

      def member(name, type, level)
        case type
        when Hash
          "#{key(name, level)} #{members(type, level)}"
        when Array
          "#{member(name, type.first, level)}[]"
        when String
          "#{key(name, level)} #{number?(type) ? 'number' : type}"
        else
          raise "unknown type => #{type.class}: #{type}"
        end
      end

      def number?(type)
        %w[integer float].include?(type)
      end

      def key(name, level)
        "#{indent(level)}#{name}:"
      end

      def indent(level)
        '  ' * level
      end
    end
  end
end
