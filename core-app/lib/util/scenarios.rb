module LT
  module Scenarios
    module Schools class << self
      def acme_high_school_data
        {
          :name=>"Acme High School"
        }
      end
    end; end # Schools
    module Teachers class << self
      def jane_doe_data
        {
          :username=>"janedoe@bar.com",
          :password=>"pass",
          :first_name=>"Jane",
          :last_name=>"Doe",
          :email=> "janedoe@bar.com",
          :staff_member=>{
            :staff_member_type=>'Teacher'
          }
        }
      end
    end; end # Teachers
    module Sites class << self
      def khanacademy_data
        {:display_name=>"Khan Academy",
        :url=>'http://www.khanacademy.org',
        site_uuid: "dd584c3e-47ee-11e4-8939-164230d1df67"
        }
      end
      def codeacademy_data
        {:display_name=>"Code Academy",
        :url=>'http://www.codeacademy.com',
        site_uuid: "bc921bb1-c7ed-421a-8e8f-e3ece2a57e53"
        }
      end
    end; end #Sites
    module SiteActions class << self
      def khanacademy_actions_data
        {:action_type=>"PAGEVIEW",
        :url_pattern=>"http(s)?://(.*\\.)?khanacademy\\.(com|org)(/\\S*)?",
        :site_url=>'http://www.khanacademy.org'
        }
      end
      def codeacademy_actions_data
        {:action_type=>"CLICK",
        :url_pattern=>"http(s)?://(.*\\.)?codeacademy\\.(com|org)(/\\S*)?",
        :site_url=>'http://www.codeacademy.com'
        }
      end
    end; end #SiteActions
    module ApprovedSites class << self
      def approved_khanacademy_data
        {:school_name=>'Acme High School',
        :site_url=>'http://www.khanacademy.org'
        }
      end
      def approved_codeacademy_data
        {:school_name=>'Acme High School',
        :site_url=>'http://www.codeacademy.com'
        }
      end
    end; end #ApprovedSites
    module Pages class << self
      def khanacademy_data
        [{:display_name=>"Converting Decimals to Fractions 2 (ex 1)",
        :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
        # this field is not part of the model - used to help seed below
        :site_url=>'http://www.khanacademy.org'},
        {:display_name=>"Converting a fraction to a repeating decimal",
        :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
        :site_url=>'http://www.khanacademy.org'}]
      end
      def codeacademy_data
        [{:display_name=>"Access Array By Index",
        :url=>'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
        :site_url=>'http://www.codeacademy.com'}]
      end
    end; end # Pages
    module Organizations class << self
      @acme_org_api_key = nil
      def acme_organization_data
        @acme_org_api_key = SecureRandom.uuid if !@acme_org_api_key
        {
          org_api_key: @acme_org_api_key
        }
      end
    end; end # Organizations
    # create a user in a section
    module Students class << self
      def joe_smith_data
        {
        :username=>"joesmith@foo.com",
        :password=>"pass",
        :first_name=>"Joe",
        :last_name=>"Smith",
        :email=> "joesmith@foo.com",
        :student=>{}
        }
      end
      def bob_newhart_data
        {
        :username=>"bob@foo.com",
        :password=>"pass2",
        :first_name=>"Bob",
        :last_name=>"Newhart",
        :email=> "bobnewhard@foo.com",
        :student=>{}
        }
      end
      def create_joe_smith_scenario
        scenario = {
          :student=>joe_smith_data,
          :student2=>bob_newhart_data,
          :section=>{
            :name=>"CompSci Period 2",
            :section_code=>"Comp Sci Room 2"
          },
          :organizations=>[
            Organizations::acme_organization_data
          ],
          :school=>Schools::acme_high_school_data,
          :teacher=>Teachers::jane_doe_data,
          :sites=>[
            Sites::khanacademy_data,
            Sites::codeacademy_data,
            
          ],
          :site_actions=>[
            SiteActions::khanacademy_actions_data,
            SiteActions::codeacademy_actions_data
          ],
          :approved_sites=>[
            ApprovedSites::approved_khanacademy_data,
            ApprovedSites::approved_codeacademy_data
          ],
          :pages=>(Pages::khanacademy_data+Pages::codeacademy_data),
          :page_visits=>[{
            # this field is not part of the model - used to help seed below
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            :date_visited=>1.day.ago,
            :time_active=>15.minutes.to_i
            },
            {
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            :date_visited=>2.days.ago,
            :time_active=>12.minutes.to_i
            },
            {
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            :date_visited=>2.days.ago,
            :time_active=>7.minutes.to_i
            },
            {
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            :date_visited=>2.weeks.ago,
            :time_active=>7.minutes.to_i
            },
            {
            :url=>'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
            :date_visited=>3.days.ago,
            :time_active=>8.minutes.to_i
            },
            {
            :url=>'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
            :date_visited=>13.days.ago,
            :time_active=>22.minutes.to_i
            }

          ]
        }  
        student = User.create_user(scenario[:student])[:user].student
        student2 = User.create_user(scenario[:student2])[:user].student
        teacher = User.create_user(scenario[:teacher])[:user].staff_member
        section = Section.create(scenario[:section])
        school = School.create(scenario[:school]) 
        student.add_to_section(section)
        student2.add_to_section(section)
        teacher.add_to_section(section)
        student.add_to_school(school)
        student2.add_to_school(school)
        teacher.add_to_school(school)
        scenario[:organizations].each do |organization|
          Organization.create!(organization)
        end
        # we add all user activity data to two students
        # this is to make sure that we can find data associated with only student at a time
        [student, student2].each do |student|
          # create site records, and associated site_visited records
          # we have to tie sites_visited to sites
          # we have to tie sites_visited to users
          scenario[:sites].each do |site|
            site = site.dup
            s = Site.find_or_create_by(site)
          end
          # create page records, and associated page_visited records
          # we have to tie pages to sites as well as pages_visited
          # we have to tie pages_visited to users
          scenario[:pages].each do |page|
            page = page.dup
            s = Site.find_by_url(page[:site_url])
            page.delete(:site_url)
            p = Page.find_or_create_by(page)
            s.pages << p
            scenario[:page_visits].each do |page_visit|
              page_visit = page_visit.dup
              if p.url == page_visit[:url] then
                page_visit.delete(:url)
                pv = PageVisit.create(page_visit)
                p.page_visits << pv
                student.page_visits << pv
              end
            end
          end
        end #[student, student2].each do |student|
        # create site actions and site approvals for the school
        
        # Attach site actions for each site
        scenario[:site_actions].each do |site_action|
          site_action = site_action.dup
          site = Site.find_by_url(site_action[:site_url])
          site_action.delete(:site_url)
          sa = SiteAction.create(site_action)
          site.site_actions << sa
        end # scenario[:site_actions].each do |site_action|

        # Attach approval for the two sites at the school level
        scenario[:approved_sites].each do |approved_site|
          approved_site = approved_site.dup
          site = Site.find_by_url(approved_site[:site_url])
          approved_site.delete(:site_url)
          as = ApprovedSite.new
          as.school_id = school.id
          as.site_id = site.id
          as.save
        end # scenario[:approved_sites].each do |approved_site|

        scenario
      end # create_joe_smith_seed
    end; end #Students
    module RawMessages class << self
      def raw_messages_scenario_data
        new_student_username = "newuser@novel.com"
        scenario = {
          new_student: {username: new_student_username},
          students: [
            Students::joe_smith_data,
            Students::bob_newhart_data
          ],
          organizations: [
            Organizations::acme_organization_data
          ],
          raw_messages: [
            {
            username: Students::joe_smith_data[:username],
            site_uuid: Sites::khanacademy_data[:site_uuid],
            verb: "viewed",
            action:
              { time: "8M21S" },
            captured_at: 8.days.ago.iso8601,
            api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
            url: Pages::khanacademy_data[0][:url]
            },
            {
            username: Students::joe_smith_data[:username],
            site_uuid: Sites::khanacademy_data[:site_uuid],
            verb: "viewed",
            page_title: Pages::khanacademy_data[0][:display_name],
            action:
              { time: "12M1S" },
            captured_at: 2.days.ago.iso8601,
            api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
            url: Pages::khanacademy_data[0][:url]
            },
            {
            username: Students::joe_smith_data[:username],
            site_uuid: Sites::khanacademy_data[:site_uuid],
            verb: "viewed",
            action:
              {}, # note - we don't provide value/time key for this record
            captured_at: 1.day.ago.iso8601,
            api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
            url: Pages::khanacademy_data[1][:url]
            },
            {
            username: Students::bob_newhart_data[:username],
            site_uuid: Sites::khanacademy_data[:site_uuid],
            verb: "viewed",
            action:
              { time: "2M1S" },
            captured_at: 2.days.ago.iso8601,
            api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
            url: Pages::khanacademy_data[0][:url]
            }, 
            { # This is an org_api_key raw_message to validate that janitor handles both
              # this message refers to a known user
            username: Students::joe_smith_data[:username],
            verb: "viewed",
            action:
              { time: "12M24S" },
            captured_at: 4.days.ago.iso8601,
            org_api_key: Organizations::acme_organization_data[:org_api_key],
            url: Pages::khanacademy_data[0][:url]
            },
            {  # this message refers to a new user
            username: new_student_username,
            verb: "viewed",
            action:
              { time: "12M24S" },
            captured_at: 4.5.days.ago.iso8601,
            org_api_key: Organizations::acme_organization_data[:org_api_key],
            url: Pages::khanacademy_data[0][:url]
            }
          ]
        }
        scenario
      end #raw_messages_scenario_data
      def create_raw_message_redis_to_pg_scenario
        scenario = raw_messages_scenario_data
        # this holds username=>id associations
        usernames_ids = {}
        scenario[:students].each do |s|
          user = User.create_user(s)[:user]
          usernames_ids[user.username] = user.id
        end
        scenario[:organizations].each do |organization|
          Organization.create!(organization)
        end
        scenario[:raw_messages].each do |raw_message|
          # delete username and swap in the user_id
          # except for the org_api_key record which is supposed to have username
          if raw_message[:org_api_key].nil? then
            raw_message[:user_id]=usernames_ids[raw_message.delete(:username)]
          end
          if raw_message[:user_id].nil? && raw_message[:org_api_key].nil? then
            raise StandardError
          end
          json_message = raw_message.to_json
          LT::RedisServer::raw_message_push(json_message)
        end
        scenario
      end
    end; end # RawMessages
  end # Scenarios module
end # LT module

