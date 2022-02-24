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

desc "Type check via tests"
task :rbs do |t|
  sh "bundle exec rbs test --target 'ClusterID::*' bundle exec rake test"
end
