# frozen_string_literal: true

module Katarina
  module Configurable
    def configure(&block)
      block.call(config)
    end

    def config
      @config ||= Config.new
    end
  end
end
