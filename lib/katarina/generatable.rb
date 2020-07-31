# frozen_string_literal: true

using RubyNext

module Katarina
  module Generatable
    def generate
      Parser
        .parse(Katarina.config.input_path)
        .group_by(&:controller)
        .each do |controller, schemas|
          schemas
            .map(&TypeGenerator.method(:generate))
            .join("\n")
            .then { Printer.write(_1, controller.split('/')) }
        end
    end
  end
end
