gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
# some likely testing gems we'll want
# TimeCop, chronic, tempfile, uri


class HTMLExtractTest < Minitest::Test
  def setup
    # set database transaction
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    # seed data for tests
    LT::Janitor::Seeds::seed!
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_sample
    assert true
    #result = ActiveRecord::Base.connection.execute('select * from raw_messages')
    #puts result.class.instance_methods.inspect
    #puts "wait"
    #STDIN.gets
    msgs = RawMessage.where(status: "READY")
    msgs.each do |msg|
      puts msg.api_key
      assert true
    end
  end
end