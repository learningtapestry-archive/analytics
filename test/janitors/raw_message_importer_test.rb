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
    @importer = RawMessageImporter.new(@logger, 2)
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

  def test_updates_viewed_message_if_already_exists
    generated_page = page
    RawMessage.create!(generated_page.merge(captured_at: '01/08/2015 00:00:00', processed_at: '30/08/2015 00:00:00'))
    last_message = RawMessage.create!(generated_page.merge(captured_at: '02/08/2015 00:00:00'))
    messages_queue.clear
    messages_queue.push(generated_page.merge(action: { time: '450S' }, captured_at: '31/08/2015 00:00:00').to_json)

    @importer.import
    last_message.reload

    assert_equal last_message.action['time'], '450S'
    assert_equal last_message.captured_at.to_s(:db), '2015-08-31 00:00:00'
  end

  def test_processes_viewed_messages_in_correct_order
    generated_page = page
    RawMessage.create!(generated_page.merge(captured_at: '01/08/2015 00:00:00', processed_at: '30/08/2015 00:00:00'))
    last_message = RawMessage.create!(generated_page.merge(captured_at: '02/08/2015 00:00:00'))
    messages_queue.clear
    messages_queue.push(generated_page.merge(action: { time: '40S' }, captured_at: '31/08/2015 00:00:00').to_json)
    messages_queue.push(generated_page.merge(action: { time: '50S' }, captured_at: '31/08/2015 00:00:00').to_json)

    @importer.import
    last_message.reload

    assert_equal '50S', last_message.action['time']
    assert_equal '2015-08-31 00:00:00', last_message.captured_at.to_s(:db)
  end

  def test_processes_no_more_than_batch_size_messages
    messages_queue.push(unprocessed.to_json)
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

  def test_escapes_username_before_creation
    @importer.import
    messages_queue.push(page.merge(username: 'escaped%40example.com').to_json)
    @importer.import

    assert_equal 'escaped@example.com', RawMessage.last.username
  end
end
