require "sequel"

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
