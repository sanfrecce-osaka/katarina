# frozen_string_literal: true

require 'rails/railtie'
require 'pathname'

module Katarina
  class Railtie < Rails::Railtie
    rake_tasks do
      load Pathname.new(__dir__).join('rake.rb')
    end
  end
end
