# frozen_string_literal: true

module Katarina
  module TypeGenerator
    class << self
      def generate(schema)
        [
          "type #{schema.name} = {",
          members(schema.types),
          "}\n"
        ].join("\n")
      end

      private

      def members(types, level = 1)
        case types
        when Hash
          types.map { |name, type| member(name, type, level) }.join("\n")
        when Array
          "#{members(types.first, level)}[]"
        else
          types
        end
      end

      def member(name, type, level)
        case type
        when Hash
          [
            "#{key(name, level)} {",
            members(type, level + 1),
            "#{indent(level)}}"
          ]
        when Array
          if type.first != 'null'
            "#{member(name, type.first, level).join("\n")}[]"
          else
            "#{key(name, level)} null[]"
          end
        when String
          "#{key(name, level)} #{type == 'integer' ? 'number' : type}"
        end
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