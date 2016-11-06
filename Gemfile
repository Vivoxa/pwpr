source 'https://rubygems.org'

gem 'rails', '4.2.7'

gem 'aws-sdk', '~> 2'

# UI gems
gem 'bootstrap', '~> 4.0.0.alpha4'
gem 'sprockets-rails', :require => 'sprockets/railtie'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# authentication and authorisation
gem 'devise'
gem 'devise_invitable', '~> 1.7.0'
gem 'cancancan', '~> 1.10'
gem 'royce'

# DB gems
gem 'mysql2', '~> 0.3.18'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
  gem 'pry-byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development, :test do
  gem 'factory_girl_rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry'

  # Build gems
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'fudge'
  gem 'flog'
  gem 'flay'
  gem 'brakeman'
  gem 'simplecov'
  gem 'ruby2ruby'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem "chromedriver-helper"
end

group :test do
  gem 'shoulda-matchers', require: false
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
