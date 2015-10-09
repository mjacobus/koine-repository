class BaseEntity
  attr_accessor :id
end

class ArticleEntity < BaseEntity
  attr_accessor :title, :body

  private

  def method_that_should_not_be_extracted
    "dude, it should not be extracted"
  end
end
