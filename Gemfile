source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use postgres as the database for Active Record
gem 'pg'

# Use Oracle adapter for reading from Siebel
gem 'ruby-oci8'
gem "activerecord-oracle_enhanced-adapter", "~> 1.5.0"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use slim for markup
gem 'slim-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

gem 'quiet_assets'

# Use unicorn as the app server
gem 'unicorn'

group :development do
  gem 'thin'
end

# Use Capistrano for deployment
group :development do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
end

# Use RSpec for testing
group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'awesome_print'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'capybara-webkit'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'puffing-billy' # stubbing and caching proxy for testing a browser initiated external resources loading
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use DS gems
gem 'ds-sns', git: 'git@github.com:BusinessEnvironment/ds-sns-gem.git', branch: 'sns2'
gem 'ds-siebel', git: 'git@github.com:BusinessEnvironment/ds-siebel-gem.git'
gem 'ds-spark', git: 'git@github.com:BusinessEnvironment/DS-Spark-gem.git'

# Helpers
gem 'simple_form'
gem 'cancan'
gem 'kaminari'
gem 'acts-as-taggable-on'
gem 'carrierwave'
gem 'mini_magick'
gem 'rails-observers'
gem 'exception_notification'
gem 'letter_opener', group: :development
gem 'keepass-password-generator'

# Localization
gem 'russian'

# Use curb for working with external services
gem 'curb'

# Use workflow as state machine
gem 'workflow'

# Use whenever for cron tasks
gem 'whenever', require: false
