require "minitest_helper"

class SqlTest < DbTestCase
  attr_reader :adapter, :sql, :table

  def setup
    @adapter = ::TestDb.instance.adapter
    @sql = ::Koine::Repository::Persistence::Adapter::Sql.new(@adapter, :articles)
    @table = adapter[:articles]
  end

  def tear_down
    puts "foo"
  end

  def test_exposes_adapter
    assert_same adapter, sql.adapter
  end

  def test_implements_adapter_interface
    assert sql.is_a?(::Koine::Repository::Persistence::Adapter)
  end

  test "can check if record exists" do
    table.insert(title: "foo", body: "bar")

    assert sql.exists?(title: "foo")
    assert sql.exists?(body: "bar")
    assert sql.exists?(body: "bar")
    assert sql.exists?(title: "foo", body: "bar")

    refute sql.exists?(title: "foo", body: "baz")
    refute sql.exists?(title: "' or 1=1")
    refute sql.exists?(title: '" or 1=1')
  end
end
