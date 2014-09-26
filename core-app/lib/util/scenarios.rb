module LT
  module Scenarios
    # create a user in a section
    module Students class << self
      def create_joe_smith_scenario
        scenario = {
          :student=>{
            :username=>"joesmith@foo.com",
            :password=>"pass",
            :first_name=>"Joe",
            :last_name=>"Smith",
            :email=> "joesmith@foo.com",
            :student=>{}
          },
          :student2=>{
            :username=>"bob@foo.com",
            :password=>"pass2",
            :first_name=>"Bob",
            :last_name=>"Newhart",
            :email=> "bobnewhard@foo.com",
            :student=>{}
          },
          :section=>{
            :name=>"CompSci Period 2",
            :section_code=>"Comp Sci Room 2"
          },
          :teacher=>{
            :username=>"janedoe@bar.com",
            :password=>"pass",
            :first_name=>"Jane",
            :last_name=>"Doe",
            :email=> "janedoe@bar.com",
            :staff_member=>{
              :staff_member_type=>'Teacher'
            }
          },
          :sites=>[
            {:display_name=>"Khan Academy",
            :url=>'http://www.khanacademy.org'},
            {:display_name=>"Code Academy",
            :url=>'http://www.codeacademy.com'},
            
          ],
          :pages=>[
            {:display_name=>"Converting Decimals to Fractions 2 (ex 1)",
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            # this field is not part of the model - used to help seed below
            :site_url=>'http://www.khanacademy.org'},
            {:display_name=>"Converting a fraction to a repeating decimal",
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            :site_url=>'http://www.khanacademy.org'},
            {:display_name=>"Access Array By Index",
            :url=>'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
            :site_url=>'http://www.codeacademy.com'}
          ],
          :site_visits=>[{
            # this field is not part of the model - used to help seed below
            :url=>'http://www.khanacademy.org', 
            :date_visited=>1.day.ago,
            :time_active=>42.minutes.to_i
            },
            {
            :url=>'http://www.khanacademy.org',
            :date_visited=>2.days.ago,
            :time_active=>33.minutes.to_i
            },
            {
            :url=>'http://www.codeacademy.com',
            :date_visited=>3.days.ago,
            :time_active=>33.minutes.to_i
            },
            {
            :url=>'http://www.codeacademy.com',
            :date_visited=>13.days.ago,
            :time_active=>44.minutes.to_i
            }
          ],
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
        student.add_to_section(section)
        student2.add_to_section(section)
        teacher.add_to_section(section)
        # we add all user activity data to two students
        # this is to make sure that we can find data associated with only student at a time
        [student, student2].each do |student|
          # create site records, and associated site_visited records
          # we have to tie sites_visited to sites
          # we have to tie sites_visited to users
          scenario[:sites].each do |site|
            site = site.dup
            s = Site.find_or_create_by(site)
            scenario[:site_visits].each do |site_visit|
              site_visit = site_visit.dup
              if s.url == site_visit[:url] then
                site_visit.delete(:url)
                sv = SiteVisit.create(site_visit)
                s.site_visits << sv
                student.site_visits << sv
              end
            end
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
        scenario
      end # create_joe_smith_seed
    end; end
  end # Scenarios module
end # LT module
