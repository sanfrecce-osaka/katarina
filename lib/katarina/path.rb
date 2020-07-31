# frozen_string_literal: true

module Katarina
  module Path
    class << self
      def include_paths(paths)
        paths.reject { Katarina.config.exclude_paths.include?(_1) }
      end

      def output_path(paths)
        [output_dir(paths), output_file_name(paths.last)].join('/')
      end

      def output_dir(paths)
        [Dir.pwd, Katarina.config.output_dir, *include_paths(paths)[0..-2]].join('/')
      end

      def output_file_name(file_name)
        file_name + '.d.ts'
      end
    end
  end
end
