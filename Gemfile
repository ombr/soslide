source 'https://rubygems.org'

ruby '2.1.2'

gem 'bourbon'
gem 'sentry-raven'
gem 'coffee-rails'
gem 'delayed_job_active_record', '>= 4.0.0'
gem 'email_validator'
gem 'flutie'
gem 'high_voltage'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'neat'
gem 'pg'
gem 'rack-timeout'
gem 'rack-contrib'
gem 'rails', '>= 4.0.0'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 4.0.2'
gem 'simple_form'
gem 'title'
gem 'uglifier'
gem 'unicorn'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'redcarpet'
gem 'font-awesome-rails'

gem 'cloudinary', github: 'cloudinary/cloudinary_gem', branch: 'master'

gem 'rails-i18n', '~> 4.0.0'

gem 'heroku'
gem 'pusher'
gem 'aws-sdk'
gem 'uptimerobot-ruby', github: 'ombr/uptimerobot-ruby'

gem 'activeadmin', github: 'gregbell/active_admin'
gem 'devise'
gem 'cancan'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '>= 2.14'
end

group :test do
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm', '>= 3.6.7'
end
