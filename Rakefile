require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

namespace :test do
  task :coveralls do
    ENV['COVERALLS'] = 'true'
    Rake::Task['test:coverage'].invoke
  end

  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['test'].invoke
  end
end

task default: :test
