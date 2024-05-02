# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.4", ">= 5.2.4.3"
# Use mysql as the database for Active Record
gem "mysql2", ">= 0.4.4", "< 0.6.0"
# Use Puma as the app server
gem "puma", "~> 3.12"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0", ">= 5.0.7"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"

gem "addressable"
gem "rubyzip"

gem "rack-cors"

gem "icalendar"

gem "remove_emoji"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Facebook Library to Access GraphAPI
gem "koala"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Push Notifications by expo.io
gem "exponent-server-sdk"

gem "acts-as-taggable-on"
gem "ancestry", "~> 2.1"
gem "devise"
gem "devise-token_authenticatable"
gem "doorkeeper"
gem "jquery-rails"
gem "jsoneditor-rails"
gem "select2-rails"
gem "mailjet"
gem "mimemagic", ">= 0.3.10"

gem "order_as_specified"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

gem "graphiql-rails", "1.4.11"
gem "graphql", "1.9.21"
gem "graphql-query-resolver"

gem "lograge"
gem "rollbar"
gem "search_object"
gem "search_object_graphql", "0.3.2"
gem "unicorn"

# Storage to minio service
gem "aws-sdk-s3", require: false

# Hintergrunddienst delayed job
gem "better_delayed_job_web"
gem "daemons"
gem "delayed_job_active_record"

# Redis Server and Connection
gem "hiredis"
gem "redis"

# Pagination
gem "bootstrap4-kaminari-views"
gem "kaminari"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "codeclimate-test-reporter"
  gem "debase"
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "linter", git: "https://github.com/ikuseiGmbH/linters.git", tag: "rubocop-0.63.1"
  gem "pry-byebug", platforms: %i[mri mingw x64_mingw]
  gem "rails-controller-testing"
  gem "rb-readline"
  gem "rspec-rails"
  gem "ruby-debug-ide"
  # Autorun rspec files on changes
  gem "annotate"
  gem "faker", git: "https://github.com/stympy/faker.git", branch: "master"
  gem "guard"
  gem "guard-rspec"
  gem "rubocop", require: false
  gem "shoulda-matchers"
  gem "simplecov"
  gem "solargraph"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.7.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "pry-rails"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
