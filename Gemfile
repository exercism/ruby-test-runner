source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby file: '.ruby-version'

gem 'json'
gem 'mandate'
gem 'minitest', '~> 5.27'
gem 'mutex_m'
gem 'rake'

group :test do
  gem 'activesupport'
  gem 'minitest-stub-const'
  gem 'mocha'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-ast'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'sexp_processor'
  gem 'simplecov', '~> 0.17.0'
end
