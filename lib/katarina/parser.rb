# frozen_string_literal: true

require 'yaml'

module Katarina
  module Parser
    class << self
      def parse(path)
        path
          .then(&File.method(:read))
          .then { YAML.load(_1, symbolize_names: true) }
          .then(&method(:build_schemas))
      end

      private

      def build_schemas(doc)
        path_and_method_pairs(doc[:paths]).flat_map do |pair|
          pair in { path:, http_method: }
          doc[:paths][path][http_method] in { responses:, summary: }
          responses.keys.map do |response_code|
            responses[response_code][:content].values in [content]
            Schema.new(
              path,
              *summary.split(' ').then { [_1.first, _1.last[1..]] },
              http_method,
              response_code,
              content[:schema]
            )
          end
        end
      end

      def path_and_method_pairs(paths)
        paths.keys.flat_map do |path|
          paths[path].keys.map do |http_method|
            { path: path, http_method: http_method }
          end
        end
      end
    end
  end
end
