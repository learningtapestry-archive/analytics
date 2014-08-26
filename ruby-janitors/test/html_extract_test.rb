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
    # re-seed data for each test
    LT::Janitor::Seeds::seed!
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_extract_html
    #LT::Loaders::extract_html
    assert true
    puts "extract"
    msgs = RawMessage.where(status: "READY")
    puts msgs.count
    puts "****"
    msgs.each do |msg|
      puts msg.api_key
      puts "xxx"
      assert true
    end
  end

  def test_sample
    puts "sample"
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