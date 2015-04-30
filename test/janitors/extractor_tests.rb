require 'utils/scenarios'

module ExtractorTests
  include Analytics::Utils::Scenarios::RawMessages
  include Analytics::Janitors

  def test_processes_raw_messages
    @extractor.extract

    refute_nil RawMessage.first.processed_at
  end

  def test_creates_processed_objects
    @extractor.extract

    assert_equal 1, @target.count
  end

  def test_processes_no_more_than_batch_size_visits
    RawMessage.create!(page)
    @extractor.extract

    assert_equal 1, @target.count
  end

  def test_logs_sucesses
    @extractor.extract

    assert_includes @logger.debug_output.string, 'Success'
  end

  def test_logs_errors
    invalidate_raw_message

    @extractor.extract

    assert_includes @logger.debug_output.string, 'Error'
  end

  def test_logs_final_stats
    @extractor.extract

    assert_includes @logger.debug_output.string, '1 processed / 0 failures'
  end
end
