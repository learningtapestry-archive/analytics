require 'test_helper'

require File::join(LT.environment.janitor_path,'redis_postgres_extract.rb')
require 'utils/scenarios'

class PageVisitModelTest < LT::Test::DBTestBase
  def setup
    super
    LT::Seeds::seed!
  end

  def test_validation_from_json
    # show that PageVisit won't create a record with an invalid raw message verb
    scenario = Analytics::Utils::Scenarios::RawMessages::create_raw_message_redis_to_pg_scenario
    Analytics::Janitors::RedisPostgresExtract::redis_to_raw_messages
    raw_message = RawMessage.limit(1).first
    assert_equal "viewed", raw_message.verb
    raw_message.verb = "foobar"
    raw_message.save
    retval = PageVisit.create_from_raw_message(raw_message)
    assert_equal retval[:exception], ActiveRecord::StatementInvalid
    assert !retval[:page_visit]
  end
end
