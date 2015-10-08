$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERALLS']
  require 'coveralls'
  Coveralls.wear!
end

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter "/test/"
    add_group "Repository", "lib/koine/repository/repository"
    add_group "Persistency", "lib/koine/repository/persistence"
  end
end

if ENV['SCRUTINIZER']
  require 'scrutinizer/ocular'
  Scrutinizer::Ocular.watch!
end

require "sequel"
require 'koine/repository'
require 'minitest/autorun'

class TestDb
  def self.instance
    @@instance ||= self.new
  end

  def adapter
    @adapter ||= Sequel.connect(ENV.fetch("DATABASE_URL"))
  end

  def self.inside_transaction(&block)
    instance.adapter.transaction(rollback: :always) do
      block.call
    end
  end
end

class DbTestCase < Minitest::Test
  def self.test(argument, &block)
    define_method "test_#{argument.gsub(' ','_')}" do
      TestDb.inside_transaction do
        instance_eval(&block)
      end
    end
  end
end
