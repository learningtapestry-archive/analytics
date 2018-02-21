# frozen_string_literal: true

require 'test_helper'

require 'utils/scenarios'
require 'janitors/raw_message_deleter'

class RawMessageDeleterTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages
  include Analytics::Janitors

  def setup
    super

    @logger = TestLogger.new
    @deleter = RawMessageDeleter.new
  end

  def test_deletes_old_processed_raw_messages
    generated_page = page

    one = RawMessage.create!(
      generated_page.merge(
        captured_at: 2.days.ago.to_s,
        processed_at: 2.days.ago + 5.minutes
      )
    )

    two = RawMessage.create!(
      generated_page.merge(
        captured_at: 6.hours.ago.to_s,
        processed_at: 6.hours.ago + 5.minutes
      )
    )

    three = RawMessage.create!(
      generated_page.merge(
        captured_at: 2.days.ago.to_s
        # not processed yet
      )
    )

    assert_equal 3, RawMessage.count

    @deleter.run

    assert_equal 2, RawMessage.count

    remaining_ids = RawMessage.pluck(:id)

    assert_includes remaining_ids, two.id
    assert_includes remaining_ids, three.id
  end
end
