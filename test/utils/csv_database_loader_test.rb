require 'test_helper'

require 'utils/csv_database_loader'
require 'lt/core/errors'

class CsvDatabaseLoaderTest < LT::Test::DBTestBase
  include Analytics::Utils

 def test_load_when_file_name_does_not_match_existing_model
    suspend_log_level do
      assert_raises LT::ModelNotFound do
        CsvDatabaseLoader.new(csv_full_path('fail_cases/schools_invalid.csv')).load
      end
    end
  end

  def test_load_when_file_name_does_not_exist
    suspend_log_level do
      assert_raises LT::FileNotFound do
        CsvDatabaseLoader.new(csv_full_path('fail_cases/schools_missing.csv')).load
      end
    end
  end

  def test_load_when_csv_file_has_invalid_format
    suspend_log_level do
      assert_raises LT::InvalidFileFormat do
        CsvDatabaseLoader.new(csv_full_path('fail_cases/visualizations.csv')).load
      end
    end
  end

  def test_load_file_successfully
    CsvDatabaseLoader.new(csv_full_path('schools.csv')).load

    assert_equal 1, School.count
    assert_equal 1, School.first.id
    assert_equal 'Acme School', School.first.name
  end

  def test_load_directory_with_a_folder_that_does_not_exist
    dir = File.join(File.dirname(__FILE__), 'invalid')

    suspend_log_level do
      assert_raises LT::PathNotFound do
        CsvDatabaseLoader.load_directory(File.join(fixtures_path, 'invalid'))
      end
    end
  end

  def test_cvs_load_directory_successfully
    CsvDatabaseLoader.load_directory(fixtures_path)

    assert_equal 1, School.count
    assert_equal 1, Organization.count
  end

  private

  def fixtures_path
    File.join(File.dirname(__FILE__), '../fixtures')
  end

  def csv_full_path(file)
    File.join(fixtures_path, file)
  end
end
