gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
# some likely testing gems we'll want
# TimeCop, chronic, tempfile, uri
require File::join(LT::Janitor::lib_path, 'loaders.rb')

class HTMLExtractTest < Minitest::Test
  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    ## TODO: Question should seed! go up into before_suite to reduce reload time?
    # re-seed data for each test
    LT::Janitor::Seeds::seed!
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_extract_html
    LT::Loaders::extract_html
    msgs = RawMessage.where(status: "READY")
    assert_equal 3, msgs.count
  end

  def test_sample
    assert true
    #result = ActiveRecord::Base.connection.execute('select * from raw_messages')
    #puts result.class.instance_methods.inspect
    #puts "wait"
    #STDIN.gets
  end
end