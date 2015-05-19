source 'https://rubygems.org'
gem 'rake'

# core gems (need to be careful about version updating)
gem 'activesupport', '~> 4.2.0'
gem 'activerecord', '~> 4.2.0'
gem 'sinatra', '~> 1.4.5'

# additional gems (probably can accept new major versions without breaking)
gem 'log4r', '>= 1.1.10'
gem 'pg', '>= 0.17.1'
gem 'htmlentities', '>= 4.3.2'
gem 'nokogiri', '>= 1.6.3.1'
gem 'redis', '>= 3.1.0'
gem 'bcrypt', '>= 3.1.7'
gem 'chronic', '>= 0.10.2'
gem 'chronic_duration', '>= 0.10.6'
# allows printing with colors to terminal
gem 'term-ansicolor', '>= 1.3.0'
# public suffix is a project that helps decompose web hosts into their
# meaningful parts (e.g. to figure out google.co.uk and google.com both are "google")
# Possibly useful in the future so documenting here
# gem 'public_suffix'
# squasher - used in development to compress migration files

# gems for use only in non-production environments
group :dev_test do
  gem 'capybara', '>= 2.4.3'
  gem 'thin', '>= 1.6.3' # development
  # gems that probably don't need version control
  gem 'minitest', '>= 5.4.0'
  gem 'rerun', '>=0.10.0' # process reload agent, helpful for sinatra development
  gem 'database_cleaner', '>= 1.3.0'
  # poltgereist depends on phantomjs being installed on system
  # sudo apt-get install phantomjs
  gem 'poltergeist', '>= 1.5.1'
  gem 'launchy' # required by capybara to open web browser automatically
  gem 'selenium-webdriver', '>=2.43.0'
  # capybara-webkit requires qt install
  # sudo apt-get install libqt4-dev
  gem 'capybara-webkit', '>=1.3.1'
end

gem 'lt-core', :git => 'https://792de6a69ea9f5e82e17ca9d46d920b19462cfe4@github.com/learningtapestry/core'
