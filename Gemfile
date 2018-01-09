source 'https://rubygems.org'

gem 'rake'

# Core gems
gem 'activerecord', '~> 4.2.1'
gem 'activesupport', '~> 4.2.1'
gem 'lt-core', git: 'https://github.com/learningtapestry/core', ref: '72a5e74'
gem 'sinatra', '~> 1.4.5'

# Additional gems
gem 'log4r', '>= 1.1.10'
gem 'pg', '>= 0.17.1'
gem 'htmlentities', '>= 4.3.2'
gem 'nokogiri', '>= 1.6.3.1'
gem 'redis', '>= 3.1.0'
gem 'bcrypt', '>= 3.1.7'
gem 'oj'

gem 'chronic', '>= 0.10.2'
gem 'chronic_duration', '>= 0.10.6'
gem 'whenever', require: false

# Allows printing with colors to terminal
gem 'term-ansicolor', '>= 1.3.0'

# TODO: Enable in order to fix #165
# gem 'public_suffix'

# Gems for use only in non-production environments
group :dev_test do
  gem 'capybara', '>= 2.4.3'
  gem 'thin', '>= 1.6.3'
  gem 'minitest', '~> 5.7'
  gem 'database_cleaner', '>= 1.3.0'
  gem 'poltergeist', '>= 1.5.1'
  gem 'byebug'
  gem 'simple_xlsx_reader'
  gem 'ffaker'
end

