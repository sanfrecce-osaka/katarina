# frozen_string_literal: true

require 'rspec/openapi'

module Katarina
  class Config
    attr_accessor :output_dir, :exclude_paths, :prefix
    attr_writer :input_path

    def initialize
      @input_path = RSpec::OpenAPI.path
      @output_dir = [*@input_path.split('/')[0..-2], 'types'].join('/')
      @exclude_paths = []
      @prefix = true
    end

    def input_path
      [Dir.pwd, @input_path].join('/')
    end
  end
end
