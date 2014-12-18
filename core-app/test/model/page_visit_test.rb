test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

require File::join(LT::janitor_path,'redis_postgres_extract.rb')

class PageVisitModelTest < LTDBTestBase
  def setup
    super
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


  def teardown
    super
  end
end

