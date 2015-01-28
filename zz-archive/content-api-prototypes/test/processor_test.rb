require 'minitest/autorun'
require File.expand_path('../../lib/processor', __FILE__)

class ProcessorTest < MiniTest::Test

  def test_process
    assert true
    LRProcessor.process_directory('.')
  end

end