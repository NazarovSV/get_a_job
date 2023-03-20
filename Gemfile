# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'aasm'
gem 'active_model_serializers', '~> 0.10'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'breadcrumbs_on_rails'
gem 'devise'
gem 'geocoder'
gem 'globalize', '~> 6.2'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'pg', '~> 1.1'
gem 'pg_search'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rails', '~> 6.1.7'
gem 'russian_central_bank'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'slim-rails'
gem 'telephone_number'
gem 'turbolinks', '~> 5'
gem 'validate_url'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'launchy'
  gem 'pundit-matchers', '~> 1.8.4'
  gem 'rails-controller-testing'
  gem 'rspec-prof'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'shoulda-matchers'
  gem 'webdrivers'
  gem 'webrick', '~> 1.8'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
