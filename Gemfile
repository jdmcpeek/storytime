source 'https://rubygems.org'
ruby '2.3.1'
gem 'pg'
gem 'rack-contrib', '~> 1.4'
gem 'airbrake'
# authentication
gem 'bcrypt'
gem 'jwt'
gem 'multi_json'
# bot stuff
# gem 'puma', 	'~>3.4.0'
gem 'puma'
gem 'facebook-messenger'
gem 'fcm'
gem 'sinatra'

# gem 'i18n', '~> 0.7.0'
gem 'i18n'

# birdv stuff
gem 'httparty'
gem 'rake'
gem 'sequel'
gem 'sequel_pg', '~> 1.6', '>= 1.6.13'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'clockwork'
gem 'pony'
gem 'twilio-ruby'

gem 'dotenv'

group :production do
	gem 'newrelic_rpm'
end

group :development do
  # gem "better_errors"
  gem "sinatra-contrib"
end


group :test do
	gem 'fuubar'
	gem 'email_spec'
	gem 'pry'
	gem 'pry-nav'
	gem 'rack-test'
	gem 'rspec'
	gem 'webmock'
	gem 'capybara'
	gem 'rspec-sidekiq'
	gem 'factory_girl'
	gem "fakeredis", :require => "fakeredis/rspec"
	gem 'database_cleaner'
	gem 'rspec-mocks'
	gem 'timecop'
=begin
	gem 'capybara'
	gem 'selenium-webdriver'
	gem 'pry', "= 0.10.0"
	gem 'pry-nav'
	gem 'factory_girl'
=end	
end

