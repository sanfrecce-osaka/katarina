# frozen_string_literal: true

require 'ruby-next'
require 'ruby-next/language/setup'
RubyNext::Language.setup_gem_load_path(transpile: true)

require 'katarina/version'
require 'katarina/config'
require 'katarina/path'
require 'katarina/schema'
require 'katarina/parser'
require 'katarina/printer'
require 'katarina/type_generator'
require 'katarina/generatable'
require 'katarina/configurable'
require 'katarina/railtie' if defined?(Rails)

module Katarina
  extend Generatable
  extend Configurable
end
