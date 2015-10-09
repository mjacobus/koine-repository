
require "minitest_helper"

describe Koine::Hydrator::Hydrator do
  subject { Koine::Hydrator::Hydrator.new }
  let(:entity) { ArticleEntity.new }
  let(:data) do
    { id: 1, title: "title", "body" => "the body" }
  end

  describe "#hydrate" do
    it "hydrates object" do
      subject.hydrate(data, entity)

      entity.id.must_equal data[:id]
      entity.title.must_equal data[:title]
      entity.body.must_equal data["body"]
    end
  end

  describe "#extract" do
    it "extracts data from object with symbols as keys" do
      entity.id = data[:id]
      entity.title = data[:title]
      entity.body = data["body"]

      subject.extract(entity).must_equal(
        id: entity.id,
        title: entity.title,
        body: entity.body,
      )
    end
  end
end
