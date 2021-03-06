$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

if ENV['COVERALLS']
  require "coveralls"
  Coveralls.wear!
end

if ENV['COVERAGE']
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"
    add_group "Repository", "lib/koine/repository/repository"
    add_group "Persistency", "lib/koine/repository/persistence"
  end
end

if ENV['SCRUTINIZER']
  require "scrutinizer/ocular"
  Scrutinizer::Ocular.watch!
end

require "koine/repository"
require "minitest"
require "minitest/autorun"
require "support/database"
require "support/db_test_case"
require "support/article_entity"
