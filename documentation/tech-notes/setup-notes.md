lt-dev01.betaspaces.com

Postgres install (Debian/Ubuntu)
  sudo apt-get install postgres-client
  sudo apt-get install libpq-dev (develop libs)

Chrome plugin
  Zip
  CRX extension
  Drag/drop into Extensions folder in Chrome
  Approved site list is loaded dynamically from http://lt-dev01.betaspaces.com/api/v1/user/approved-sites

Nginx
  Install Lua module

Ruby-Pg dequeue
  Ruby: 1.9.3
  Bundler: gem install bundler
  Setup db/config.yml file with correct login info
  rake db:create
  rake db:migrate

  https://github.com/science/learntaculous/blob/master/ruby-janitors/redis-to-postgres-html-dequeue.rb
  # needs sql optimization for data load

# Gemfiles

To use Gemfiles see bundler.io

To install: sudo gem install bundler

To use: bundler install or bundler update

To remove all gems not required in this file:

  sudo bundle clean --force # Note: normally sudo isn't good for bundle but this is an exception
  
This helps ensure that you aren't depending on a gem that isn't installed from this list

To bundle gems for production or staging, recommend:
  
  bundle install --without test

If you want to manage different ruby installations with different gemsets for different projects

Consider installing RVM to help manage that.
