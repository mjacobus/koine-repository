class Article
  attr_accessor :id, :body, :title, :published
end

class ArticlesRepository < Koine::Repository::IdAwareEntityRepository
  def published
    find_all_by(published: true)
  end
end

db_adapter = Sequel.connect(db_string)

articles_storage = ::Koine::Repository::Persistence::Sql.new(
  db_adapter,
  :articles
)

repository = ArticlesRepository.new(articles_adapter)

published_articles = repository.published

# Prefer dependency injection

container = ApplicationDependencies.new

container.set(:db_connection) do |di|
  Sequel.connect("mysql://root@localhost/some_db")
end

container.set(:articles_persistence) do |di|
  Koine::Repository::Persistence::Sql.new(
    di.get(:db_connection),
    :articles
  )
end

container.set(ArticlesRepository) do |di|
  repository                  = ArticlesRepository.new(di.get(:articles_persistence))
  repository.hydrator         = Koine::Hydrator::Hydrator.new
  repository.entity_prototype = Article.new

  repository
end

# In your controller

class ArticlesController < MyBaseController
  def index
    @articles = repository.published
  end

  def create
    @article = Article.new
    set_attributes(@article)

    # validate as you wish

    repository.save(@article)

    redirect_to :articles_path, notice: "Article with id #{@article.id} created"
  end

  def update
    @article = repository.find(params[:id])
    set_attributes(@article)

    # validate

    repository.update(@article)
  end

  def destroy
    @article = repository.find(params[:id])
    repository.remove(@article)
  end

  private

  def set_attributes(article)
    article.title     = params[:title]
    article.body      = params[:body]
    article.published = params[:published]
  end

  def repository
    @repository ||= dependencies.get(ArticlesRepository)
  end
end
