gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
require './lib/lt_base.rb'
require './lib/util/session_manager.rb'

class SessionManagerTest < Minitest::Test

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_ValidateUser_GetApiKey
    # Missing parameter
    skip "coming soon"
  end


end
