require "minitest_helper"

class ArticleRepository < Koine::Repository::Repository
  include Koine::Repository::IdAwareEntity
end

describe Koine::Repository::IdAwareEntity do
  let(:adapter) { Minitest::Mock.new }

  let(:repository) do
    repo = ArticleRepository.new(adapter)
    repo.entity_prototype = ArticleEntity.new
    repo
  end

  let(:entity) do
      entity = ArticleEntity.new
      entity.title = "foo"
      entity.body = "bar"
      entity
  end

  describe "#find" do
    it "when entity is found it returns hydrated entity" do
      adapter.expect(:find_one_by, { id: 1, title: "foo", body: "bar" }, [id: 1])

      entity = repository.find(1)

      adapter.verify

      entity.must_be_instance_of(ArticleEntity)
      entity.id.must_equal 1
      entity.title.must_equal "foo"
      entity.body.must_equal "bar"
    end

    it "returns nil when data is not found" do
      adapter.expect(:find_one_by, nil, [id: 1])

      entity = repository.find(1)

      adapter.verify
      entity.must_be_nil
    end
  end

  describe "#creates" do
    it "creates an entity and assigns an id" do
      extracted_values = { title: "foo", body: "bar" }
      adapter.expect(:insert, 5, [extracted_values])

      repository.create(entity)

      adapter.verify
      entity.id.must_equal 5
    end
  end

  describe "#update" do
    it "updates by id" do
      entity.id = :id
      adapter.expect(:update_where, true, [{id: :id}, { title: "foo", body: "bar" }])

      repository.update(entity)

      adapter.verify
    end
  end
end
