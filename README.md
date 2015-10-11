# Koine::Repository

If you want to use repository pattern as your way into the database

[![Build Status](https://travis-ci.org/mjacobus/koine-repository.svg)](https://travis-ci.org/mjacobus/koine-repository)
[![Code Coverage](https://scrutinizer-ci.com/g/mjacobus/koine-repository/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/mjacobus/koine-repository/?branch=master)
[![Code Climate](https://codeclimate.com/github/mjacobus/koine-repository/badges/gpa.svg)](https://codeclimate.com/github/mjacobus/koine-repository)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/mjacobus/koine-repository/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/mjacobus/koine-repository/?branch=master)
[![Dependency Status](https://gemnasium.com/mjacobus/koine-repository.svg)](https://gemnasium.com/mjacobus/koine-repository)
[![Gem Version](https://badge.fury.io/rb/koine-repository.svg)](https://badge.fury.io/rb/koine-repository)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koine-repository'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install koine-repository

## Usage

Given you have a table called ```articles``` with fields:

- id
- body
- title
- published

You can create your entity as follows:

```ruby
class Article
  attr_accessor :id, :body, :title, :published
end
```

Then you can create a repository class for your articles

```ruby
class ArticlesRepository < Koine::Repository::Repository
  # adds methods find(id), create(entity) and update(entity)
  include Koine::Repository::Repository::IdAwareEntity

  def published
    find_all_by(published: true)
  end
end
```

### Putting all together:

With repositories nothing is magic. You need to instantiate your classes and
give them their dependencies.

Then you can start using your classes. Here is how you manually instantiate your
classes:

```ruby
db_adapter = Sequel.connect(db_string)

articles_storage = ::Koine::Repository::Persistence::Sql.new(
  db_adapter,
  :articles
)

repository = ArticlesRepository.new(articles_adapter)
```

To make creation of objects easier, you should use factories or some kind
of dependency injection solution.

It could be as in the example bellow;

```ruby
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
```

### Using your repository:

Accessing the repository in your controller:

```ruby
class ArticlesController < MyBaseController
  def index
    @articles = repository.published
  end

  def create
    @article = Article.new
    set_attributes(@article)

    # validate as you wish

    repository.create(@article)

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
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/mjacobus/koine-repository/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
