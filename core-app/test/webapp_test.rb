test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file


class WebAppTest < WebAppTestBase

  def test_homepage
    get "/"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    result = html.css('h3.panel-title').text
    assert_equal "Please Sign In", result
  end
  def test_dashboard
    teacher_username = @jane_doe[:username]
    teacher_password = @jane_doe[:password]
    teacher = User.find_by_username(teacher_username)

    request "/", method: :post, params: { username: teacher_username, password: teacher_password }
    follow_redirect!

    response_html =  Nokogiri.parse(last_response.body)
    page_title = response_html.css("title").text
    assert_equal "Learning Tapestry - Your Dashboard", page_title
    
    teacher_name = response_html.css("div.user-panel > div.info > p:first-child").text
    assert_equal "Hello, #{teacher.first_name}", teacher_name

=begin
    get "/dashboard"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    title = html.css('head>title').text
    assert_equal "Learning Tapestry - Your Dashboard", title

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
=end

  end
  def test_approved_site_list
    request "/api/v1/approved-sites"
    response_json = JSON.parse(last_response.body)
    khan_found = false ; codeacad_found = false
    response_json.each do |approved_site|
      if approved_site["url"] == LT::Scenarios::Sites.khanacademy_data[:url] then khan_found = true end
      if approved_site["url"] == LT::Scenarios::Sites.codeacademy_data[:url] then codeacad_found = true end
    end

    assert_equal true, khan_found
    assert_equal true, codeacad_found
  end

  def setup
    super
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
    super
  end
end