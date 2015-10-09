require "minitest_helper"

describe Koine::Repository::Repository do
  let(:adapter) { MiniTest::Mock.new }
  let(:subject) { Koine::Repository::Repository.new(adapter) }

  describe "#save" do
    it "throws an exception" do
      begin
        subject.save(ArticleEntity.new)
        fail
      rescue RuntimeError => e
        e.message.must_equal "Method not implemented"
      end
    end
  end

  describe "#remove" do
    it "throws an exception" do
      begin
        subject.remove(ArticleEntity.new)
        fail
      rescue RuntimeError => e
        e.message.must_equal "Method not implemented"
      end
    end
  end

  describe "#adapter" do
    it "returns the adapter" do
      adapter = []
      klass = subject.class
      subject = klass.new(adapter)
      subject.adapter.must_be_same_as(adapter)
    end
  end

  describe "#hydrator" do
    it "defaults to Koine::Hydrator::Hydrator" do
      subject.hydrator.must_be_same_as(subject.hydrator)
      subject.hydrator.must_be_instance_of(Koine::Hydrator::Hydrator)
    end

    it "can be mutated" do
      hydrator = Koine::Hydrator::Hydrator.new
      subject.hydrator = hydrator

      subject.hydrator.must_be_same_as(hydrator)
    end
  end

  describe "#entity_prototype" do
    it "throws exception when no entity prototype was given" do
      begin
        subject.entity_prototype
        fail
      rescue RuntimeError => e
        e.message.must_equal "Entity prototype was not set"
      end
    end

    it "can be mutated" do
      prototype = ArticleEntity.new
      subject.entity_prototype = prototype
      subject.entity_prototype.must_be_same_as(prototype)
    end
  end

  describe "#find_all_by" do
    it "returns a collection of entities" do
      criterias = { foo: :bar }

      collection = [
        { id: 1, title: "title 1", body: "body 1" },
        { id: 2, title: "title 2", body: "body 2" },
      ]

      adapter.expect(:find_all_by, collection, [criterias])

      subject.entity_prototype = ArticleEntity.new
      entities = subject.find_all_by(criterias)

      entities.count.must_equal 2

      entities.first.must_be_instance_of ArticleEntity
      entities.first.id.must_equal 1
      entities.first.title.must_equal "title 1"
      entities.first.body.must_equal "body 1"

      entities.last.must_be_instance_of ArticleEntity
      entities.last.id.must_equal 2
      entities.last.title.must_equal "title 2"
      entities.last.body.must_equal "body 2"

      adapter.verify
    end
  end

  describe "#find_one_by" do
    it "returns an entity when found" do
      criterias = { foo: :bar }
      record = { id: 1, title: "title 1", body: "body 1" }

      adapter.expect(:find_one_by, record, [criterias])

      subject.entity_prototype = ArticleEntity.new

      # will delegate to tested method
      entity = subject.find_one_by!(criterias)

      entity.must_be_instance_of ArticleEntity
      entity.id.must_equal 1
      entity.title.must_equal "title 1"
      entity.body.must_equal "body 1"

      adapter.verify
    end

    it "returns nil when no record is found" do
      criterias = { foo: :bar }
      record = nil

      adapter.expect(:find_one_by, record, [criterias])

      subject.entity_prototype = ArticleEntity.new
      entity = subject.find_one_by(criterias)

      entity.must_be_nil

      adapter.verify
    end
  end

  describe "find_one_by!" do
    it "throws an exception when no records are found" do
      criterias = { foo: :bar }
      record = nil

      adapter.expect(:find_one_by, record, [criterias])

      subject.entity_prototype = ArticleEntity.new

      proc do
        subject.find_one_by!(criterias)
      end.must_raise Koine::Repository::Repository::RecordNotFound

      adapter.verify
    end
  end
end
