# frozen_string_literal: true

desc "generate type definition files for TypeScript from rspec-openapi's output"
task 'katarina:generate': :environment do
  Katarina.generate
end
