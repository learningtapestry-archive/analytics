gem "minitest"
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
require 'debugger'
#require 'fileutils'
#require 'tempfile'
#require 'nokogiri'
#require 'chronic'
#require 'timecop'
#require 'uri'
require 'database_cleaner'

require File::join(LT::lib_path, 'webapp.rb')

class WebAppTest < Minitest::Test
  include Rack::Test::Methods
  def test_homepage
    get "/"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    result = html.css('h3.panel-title').text
    assert_equal "Please Sign In", result
  end
  def test_dashboard
    skip "TODO:  Will need to be refactored to process a login before viewing dashboard"
    teacher_username = @jane_doe[:username]
    teacher = User.find_by_username(teacher_username)
    get "/dashboard"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    title = html.css('head>title').text
    assert_equal "Learntaculous - Your Dashboard", title

    # verify teacher's name is printed on the page
    teacher_name = html.css('p.teacher_name').text
    assert_equal teacher.full_name, teacher_name
    assert teacher_name.size>5

    # verify that student names are printed on the page
    student_names = []
    html.css('p.student_name').each do |name|
      student_names << name.text
    end
    student_names.each do |student_name_actual|  
      student_name_html = student_names.find do |name|
        name == student_name_actual
      end
      assert_equal student_name_actual, student_name_html
      assert student_name_html.size > 5
    end
    #u = User.find_by_username(@joe_smith[:username])

  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
    end
    @first_run = true
  end

  def setup
    before_suite
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @site_visits = @scenario[:site_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
  def app
    LT::WebApp
  end
end