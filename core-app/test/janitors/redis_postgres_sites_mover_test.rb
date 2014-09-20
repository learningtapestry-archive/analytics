gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'database_cleaner'
require 'date'
require File::join(LT::lib_path, 'util', 'redis_server.rb')
require File::join(LT::lib_path, 'util', 'session_manager.rb')
require File::join(LT::lib_path, 'janitors', 'redis_postgres_sites_mover.rb')

class RedisPostgresSitesMoverTest < Minitest::Test
  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def self.test_order
    :alpha # ideally, yes, I know...
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!

    LT::RedisServer::api_keys_hashlist_clear
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count

    LT::RedisServer::raw_messages_queue_clear
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count

    @scenario = LT::Seeds::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @student = Student.find_by_username(@joe_smith[:username])
    assert_equal @joe_smith[:username], @student.user.username

    # Use SessionManager to validate user and create new API key
    @api_key = LT::SessionManager.validate_user(@joe_smith[:username], @joe_smith[:password])

    # Ensure we received back API key
    match = /^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$/.match(@api_key)
    refute_nil match

    # Test in Redis that API key gives us a database name
    db_name_redis = LT::RedisServer.api_key_get(@api_key)
    assert_equal LT.get_db_name, db_name_redis

    # Test that API key from Redis matches user in Postgres
    api_key_postgres = ApiKey.get_by_api_key(@api_key)
    assert_equal api_key_postgres.user_id, @student.user_id
  end

  def test_RedisPostgresViewedMessageMove
    site_hash = "4f5978b72bf7f778629886a575375ba6" # this comes from seed data, # TODO: move to scenario
    page_url = "http://stackoverflow.com/search?q=redis+ruby"
    visit_value = "1M32S"
    timestamp = DateTime.parse("2014-09-16T13:15:59-04:00")
    raw_message =   { :user => {
                            :username => @joe_smith[:username], 
                            :apiKey => @api_key,
                            :site_hash => site_hash,
                            :action => {
                                :id => "verbs/viewed", 
                                :display => { :en_us => "viewed" }, 
                                :value => { :time => visit_value }
                                }, 
                            :url => { :id => page_url }, 
                            :timestamp => timestamp
                        }
                    }

    LT::RedisServer::raw_message_push(raw_message.to_json)

    LT::Janitors::RedisPostgresSitesMover.extract
    approved_site = ApprovedSite.get_by_site_hash(site_hash)
    refute_nil approved_site

    site = Site.where(:url => approved_site.url).first
    refute_nil site
    
    page = Page.where(:site_id => site.id, :url => page_url).first
    refute_nil page

    page_visit = PageVisit.where(:page_id => page.id, :user_id => @student.user_id, :date_visited => timestamp).first
    refute_nil page_visit
    assert_equal page_visit.time_active, "00:01:32"
  end

  def test_RedisPostgresClickedMessageMove
    site_hash = "4f5978b72bf7f778629886a575375ba6" # this comes from seed data, # TODO: move to scenario
    page_url = "http://stackoverflow.com/questions/3046607/rails-find-or-create-by-more-than-one-attribute"
    page_clicked_url = "https://ninefold.com/?utm_source=stackoverflow&utm_medium=banner&utm_content=220x250-green-side&utm_campaign=INT%20%7C%20stackoverflow"
    timestamp = "2014-09-16T13:15:59-04:00"

    raw_message =   { :user => {
                        :username => @joe_smith[:username], 
                        :apiKey => @api_key, 
                        :site_hash => site_hash, 
                        :action => {
                            :id => "verbs/clicked", 
                            :display =>{ :en_us => "clicked" }, 
                            :value => { :url => page_clicked_url }
                            }, 
                            :url=>{ :id => page_url }, 
                            :timestamp => timestamp
                        }
                    }

    LT::RedisServer::raw_message_push(raw_message.to_json)

    LT::Janitors::RedisPostgresSitesMover.extract
    approved_site = ApprovedSite.get_by_site_hash(site_hash)
    refute_nil approved_site

    site = Site.where(:url => approved_site.url).first
    refute_nil site
    
    page = Page.where(:site_id => site.id, :url => page_url).first
    refute_nil page

    page_click = PageClick.where(:page_id => page.id, :user_id => @student.user_id, :url_visited => page_clicked_url).first
    refute_nil page_click
    assert_equal page_click.url_visited, page_clicked_url
  end
end
