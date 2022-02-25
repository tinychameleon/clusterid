# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"
require "yard"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

YARD::Rake::YardocTask.new do |t|
  t.files = ["lib/**/*.rb", "-", "CHANGELOG.md"]
  t.options = ["--private", "-o", "./docs"]
end

task default: %i[test standard]

desc "Run current benchmarks"
task :benchmark do
  sh "date; bundle exec ruby test/benchmarks/current.rb"
end

desc "Type check via tests"
task :rbs do
  sh "bundle exec rbs -r date -I sig test --target 'ClusterId::*' bundle exec rake test"
end
