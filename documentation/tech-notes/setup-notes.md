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

  

