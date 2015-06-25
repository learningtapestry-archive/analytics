require 'test_helper'

require 'utils/scenarios'
require 'helpers/redis'

require 'janitors/raw_message_importer'

class RawMessageImporterTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages
  include Analytics::Helpers::Redis

  include Analytics::Janitors

  def setup
    super

    messages_queue.push(unprocessed.to_json)
    @logger = TestLogger.new
    @importer = RawMessageImporter.new(@logger, 1)
  end

  def test_removes_messages_from_redis_if_import_succeeds
    @importer.import

    assert_empty messages_queue
  end

  def test_leaves_messages_in_redis_if_import_fails

  end

  def test_creates_new_raw_message_objects_on_success
    @importer.import

    assert_equal 1, RawMessage.count
  end

  def test_processes_no_more_than_batch_size_messages
    messages_queue.push(unprocessed.to_json)

    @importer.import
    assert_equal 1, messages_queue.length
  end

  def test_logs_sucesses
    @importer.import

    assert_includes @logger.debug_output.string, 'Success'
  end

  def test_logs_final_stats
    @importer.import

    assert_includes @logger.debug_output.string, '1 processed / 0 failures'
  end
end
