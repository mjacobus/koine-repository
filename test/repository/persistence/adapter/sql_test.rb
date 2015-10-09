require "minitest_helper"

class SqlTest < DbTestCase
  attr_reader :db_connection, :adapter, :table

  def setup
    @db_connection = ::TestDb.instance.adapter
    @adapter = ::Koine::Repository::Persistence::Adapter::Sql.new(
      @db_connection,
      :articles
    )
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
    assert_equal 1, adapter.find_all_by(title: "foo", body: "bar").count
    assert_equal 2, adapter.find_all_by(title: "foo").count
  end

  test "can update based on criterias" do
    create

    new_values = { title: "updated" }
    adapter.update_where({ title: "title 1" }, new_values)

    records = adapter.find_all_by(new_values)
    assert_equal 1, records.count
  end

  test "can delete records based on criterias" do
    create

    adapter.delete_where(title: "title 1")

    records = adapter.find_all_by({})
    assert_equal 1, records.count
  end

  test "can find by id" do
    create

    records = adapter.find_all_by({})

    records.each do |record|
      assert_equal record, adapter.find(record[:id])
    end
  end

  test "can insert records" do
    adapter.insert(title: "created title", body: "created body")
    assert_equal 1, table.count
  end

  test "returns inserted id when record is created" do
    data = { title: "created title", body: "created body" }
    id = adapter.insert(data)

    record = table.where(id: id).first
    assert_equal data[:title], record[:title]
    assert_equal data[:body], record[:body]
  end

  def create(number = 2)
    (1..number).each do |i|
      table.insert(title: "title #{i}", body: "body#{i}")
    end
  end
end
