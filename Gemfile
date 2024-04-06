source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '3.3.0'

gem "mandate", "~> 1.0.0"
gem 'rake'
gem 'mutex_m'
gem 'json', '~> 2.6.1'
gem 'minitest', '~> 5.11.3'

gem 'parser'
gem 'rubocop-ast'

group :test do
  gem 'mocha'
  gem 'pry'
  gem 'simplecov', '~> 0.17.0'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
end
