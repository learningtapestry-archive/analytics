test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require 'utils/csv_database_loader'

class CsvDatabaseLoaderTest < LT::Test::DBTestBase
  def test_InvalidCSVModelMatch
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/fail_cases/schools_invalid.csv'))
    suspend_log_level do
      assert_raises LT::ModelNotFound do
        Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
      end
    end
  end

  def test_InvalidFilename
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/fail_cases/schools_doesnotexist.csv'))
    suspend_log_level do
      assert_raises LT::FileNotFound do
        Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
      end
    end
  end

  def test_InvalidCSVFile
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/fail_cases/page_visits.csv'))

    suspend_log_level do
      assert_raises LT::InvalidFileFormat do
        Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
      end
    end
  end

  def test_CSVLoadFile
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/schools.csv'))

    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)

    assert_equal 2, School.all.length

    school = School.find(1)
    assert_equal 1, school.id
    assert_equal "Acme School", school.name
  end

  def test_InvalidCSVPath
    suspend_log_level do
      assert_raises LT::PathNotFound do
        Analytics::Utils::CsvDatabaseLoader.load_directory(File::expand_path(File::join(LT.environment.db_path, '/invalid_path')))
      end
    end
  end

  def test_CSVLoadFiles
    file_path = File::expand_path(File::join(LT.environment.db_path, '/csv/test'))
    Analytics::Utils::CsvDatabaseLoader.load_directory(file_path)

    assert_equal 1, District.all.length
    assert_equal 2, School.all.length
    assert_equal 3, User.all.length
  end
end
