require "sequel"

class TestDb
  def self.instance
    @@instance ||= self.new
  end

  def db_string
    ENV['DB'] ||= 'mysql'
    ENV.fetch("DATABASE_URL_#{ENV['DB'].upcase}")
  end

  def adapter
    @adapter ||= Sequel.connect(db_string)
  end

  def self.inside_transaction(&block)
    instance.adapter.transaction(rollback: :always) do
      block.call
    end
  end
end
