# frozen_string_literal: true

require 'fileutils'

module Katarina
  module Printer
    class << self
      def write(content, paths)
        FileUtils.makedirs(Katarina::Path.output_dir(paths))
        FileUtils.touch(Katarina::Path.output_path(paths))
        File.open(Katarina::Path.output_path(paths), 'w+') { _1.write(content) }
      end
    end
  end
end
