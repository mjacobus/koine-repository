require "minitest_helper" 
class SqlTest < DbTestCase
  attr_reader :db_connection, :adapter, :table

  def setup
    @db_connection = ::TestDb.instance.adapter
    @adapter = ::Koine::Repository::Persistence::Adapter::Sql.new(@db_connection, :articles)
    @table = db_connection[:articles]
  end

  def test_exposes_adapter
    assert_same db_connection, adapter.adapter
  end

  def test_implements_adapter_interface
    assert adapter.is_a?(::Koine::Repository::Persistence::Adapter)
  end

  test "can check if record exists" do
    table.insert(title: "foo", body: "bar")

    assert adapter.exists?(title: "foo")
    assert adapter.exists?(body: "bar")
    assert adapter.exists?(body: "bar")
    assert adapter.exists?(title: "foo", body: "bar")

    refute adapter.exists?(title: "foo", body: "baz")
    refute adapter.exists?(title: "' or 1=1")
    refute adapter.exists?(title: '" or 1=1')
  end

  test "can find one by criteria" do
    table.insert(title: "foo", body: "bar")
    table.insert(title: "foo", body: "baz")

    record = adapter.find_one_by(title: "foo")

    assert "foo", record[:title]
    assert "bar", record[:body]
  end

  test "can find all by criteria" do
    table.insert(title: "foo", body: "bar")
    table.insert(title: "foo", body: "baz")
    table.insert(title: "baz", body: "baz")

    assert_equal 3, adapter.find_all_by({}).count
    assert_equal 1, adapter.find_all_by(title: 'foo', body: "bar").count
    assert_equal 2, adapter.find_all_by(title: 'foo').count
  end

  test "can update based on criterias" do
    create

    new_values = {title: "updated"}
    adapter.update_where({title: "title 1"}, new_values )

    records = adapter.find_all_by(new_values)
    assert_equal 1, records.count
  end

  def create(number = 2)
    for i in 1..number
      table.insert(title: "title #{i}", body: "body#{i}")
    end
  end
end
