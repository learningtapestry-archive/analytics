gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'
require 'debugger'
require File::join(LT::janitor_path,'redis_postgres_extract.rb')

class PageVisitModelTest < Minitest::Test
  def setup
    before_suite
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
  end

  def test_validation_from_json
    # show that PageVisit won't create a record with an invalid raw message verb
    scenario = LT::Scenarios::RawMessages::create_raw_message_redis_to_pg_scenario
    LT::Janitors::RedisPostgresExtract::redis_to_raw_messages
    raw_message = RawMessage.limit(1).first
    assert_equal "viewed", raw_message.verb
    raw_message.verb = "foobar"
    raw_message.save
    retval = PageVisit.create_from_raw_message(raw_message)
    assert_equal retval[:exception], ActiveRecord::StatementInvalid
    assert !retval[:page_visit]
  end


  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
    end
    @first_run = true
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end

