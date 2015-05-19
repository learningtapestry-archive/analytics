### Requirements

* Ruby: 2.2.1
* Bundler
* Postgresql 9.4
* Redis
* Phantomjs

#### Bundler & Gemfiles

To use Gemfiles see [bundler.io](http://bundler.io). Bundler helps you ensure
that you are using the correct versions of your gem dependencies.

* Install bundler: `gem install bundler`.
* Install Gemfile dependencies: `bundle install`.
* Update Gemfile dependencies: `bundle update`.
* Bundle gems excluding specific groups: `bundle install --without test`

#### Phantomjs for js tests

* Installation

```bash
sudo apt-get install phantomjs
```

#### Postgresql (for Debian/Ubuntu)

* Installation

```bash
sudo apt-get install postgres-client
sudo apt-get install libpq-dev # development libraries
```

* Setup to match example files information

```bash
sudo su - postgres
psql -c "CREATE USER lt_dbo WITH PASSWORD 'lt_dev_xyz_123'"
psql -c "ALTER USER lt_dbo WITH CREATEDB"
psql -c "CREATE TABLESPACE learntaculous_ts OWNER lt_dbo LOCATION '/var/lib/postgresql/9.4/main'"
```

* Create and migrate the database

```
bundle exec rake db:create
bundle exec rake db:migrate
```

#### Chrome plugins

* Zip
* CRX extension
* Drag/drop into Extensions folder in Chrome
* Approved site list is loaded dynamically from http://lt-dev01.betaspaces.com/api/v1/user/approved-sites

#### Nginx

* Install Lua module

#### Config files

* Use example config files

```bash
for f in `find -name '*-sample.yml'`; do cp "$f" "${f%-sample.yml}.yml"; done
```
