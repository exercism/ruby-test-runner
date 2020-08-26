source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mandate'
gem 'rake'
gem 'json'
gem 'minitest', '~> 5.11.3'

group :test do
  gem 'mocha'
  gem 'pry'
  gem 'simplecov', '~> 0.17.0'
end
