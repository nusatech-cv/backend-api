source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.5"

gem 'aasm'
gem 'google-api-client'
gem 'googleauth'
gem 'carrierwave', '~> 2.1', '>= 2.1.0'
gem 'fog-aws', '~> 3.5.2'
gem 'cancancan', '~> 2.3.0'
gem 'hiredis', '~> 0.6.1'
gem 'mini_racer', platforms: :ruby
gem 'rack-cors', '~> 1.0.2'
gem 'rack-attack', '>= 6.5.0'
gem 'jwt', '~> 2.2'
gem 'jwt-multisig', '~> 1.0', '>= 1.0.4'
gem 'bunny'
gem 'signet'
gem 'grape', '~> 1.4'
gem 'grape-entity', '~> 0.8'
gem 'grape_logging', '~> 1.8'
gem 'vault',        '~> 0.1'
gem 'vault-rails'
gem "rails", "~> 7.0.6"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem 'pry-rails'
gem 'dotenv-rails'
gem 'memoist', '~> 0.16'
gem "redis", "~> 4.0"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'kaminari', '>= 1.2.1'
gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'geocoder'
gem 'activerecord-postgis-adapter'
gem 'faker'
gem 'geokit-rails'
gem 'user_agent'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'pry-byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'listen'
  gem 'grape_on_rails_routes'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
