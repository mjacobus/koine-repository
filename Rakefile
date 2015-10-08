require "bundler/gem_tasks"
require "rake/testtask"
require "dotenv"

Dotenv.load

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

  task :scrutinizer do
    ENV['SCRUTINIZER'] = 'true'
    Rake::Task['test'].invoke
  end
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end

  task :create do
    puts "please create manually your table"
  end
end

task default: :test
