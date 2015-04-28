module Analytics
  module Utils
    module Scenarios
      module Schools
        def acme_high_school_data
          { name: 'Acme High School' }
        end
      end

      module Teachers
        def jane_doe_data
          {
            username: 'janedoe@bar.com',
            password: 'pass',
            first_name: 'Jane',
            last_name: 'Doe',
            email: 'janedoe@bar.com',
            profile_attributes: { type: 'Teacher' }
          }
        end
      end

      module Sites
        def khanacademy
          {
            display_name: 'Khan Academy',
            url: 'www.khanacademy.org',
            site_uuid: 'dd584c3e-47ee-11e4-8939-164230d1df67',
            site_actions_attributes: [
              {
                action_type: 'PAGEVIEW',
                url_pattern: 'http(s)?://(.*\\.)?khanacademy\\.(com|org)(/\\S*)?',
              }
            ]
          }
        end

        def codeacademy
          {
            display_name: 'Code Academy',
            url: 'www.codeacademy.com',
            site_uuid: 'bc921bb1-c7ed-421a-8e8f-e3ece2a57e53',
            site_actions_attributes: [
              {
                action_type: 'CLICK',
                url_pattern: 'http(s)?://(.*\\.)?codeacademy\\.(com|org)(/\\S*)?',
              }
            ]
          }
        end
      end

      module Pages
        def khanacademy_page1
          {
            display_name: 'Converting Decimals to Fractions 2 (ex 1)',
            url: 'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            visits_attributes: [
              { date_visited: 1.day.ago, time_active: '15 minutes' },
              { date_visited: 2.days.ago, time_active: '12 minutes' }
            ]
          }
        end

        def khanacademy_page2
          {
            display_name: 'Converting a fraction to a repeating decimal',
            url: 'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            visits_attributes: [
              { date_visited: 2.days.ago, time_active: '7 minutes' },
              { date_visited: 2.weeks.ago, time_active: '7 minutes' }
            ]
          }
        end

        def codeacademy_page
          {
            display_name: 'Access Array By Index',
            url: 'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
            visits_attributes: [
              { date_visited: 3.days.ago, time_active: '9 minutes' },
              { date_visited: 13.days.ago, time_active: '22 minutes' }
            ]
          }
        end
      end

      module Organizations
        def acme_organization_data
          {
            name: 'Acme Organization',
            org_api_key: SecureRandom.uuid,
            org_secret_key: SecureRandome.hex(36)
          }
        end
      end

      # create a user in a section
      module Students
        include Schools
        include Sites
        include Organizations
        include Teachers

        def joe_smith_data
          {
            username: 'joesmith@foo.com',
            password: 'pass',
            first_name: 'Joe',
            last_name: 'Smith',
            profile_attributes: { type: 'Student' },
            emails_attributes: [{ email: 'joesmith@foo.com' }]
          }
        end

        def bob_newhart_data
          {
            username: 'bob@foo.com',
            password: 'pass2',
            first_name: 'Bob',
            last_name: 'Newhart',
            profile_attributes: { type: 'Student' },
            emails_attributes: [{ email: 'bobnewhard@foo.com' }]
          }
        end

        def create_joe_smith_scenario
          scenario = {
            student: joe_smith_data,
            student2: bob_newhart_data,
            section: {
              name: 'CompSci Period 2', section_code: 'Comp Sci Room 2'
            },
            organization: acme_organization_data,
            school: acme_high_school_data,
            teacher: jane_doe_data,
            pages: [khanacademy_page1, khanacademy_page2, codeacademy_page],
         }

          section = Section.create!(scenario[:section])
          school = School.create!(scenario[:school])

          student = User.create!(scenario[:student])
          student2 = User.create!(scenario[:student2])
          teacher = User.create!(scenario[:teacher])

          SectionUser.create!([ { user: student, section: section },
                                { user: student2, section: section },
                                { user: teacher, section: section }])


          student.update!(school: school)
          student2.update!(school: school)
          teacher.update!(school: school)

          organization = Organization.create!(scenario[:organization])

          student.update!(organization: organization)
          student2.update!(organization: organization)

          Page.create!(scenario[:pages])
          Visit.find_each { |visit| visit.update!(user: student1) }

          ApprovedSite.create(school: school, site: site1)
          ApprovedSite.create(school: school, site: site2)
        end
      end

      module RawMessages
        include Sites
        include Pages
        include Students
        include Organizations

        def base
          {
            username: 'steve@example.com',
            url: 'http://stackoverflow.com/interesting',
            captured_at: '01/01/2015 00:00:00',
            processed_at: nil,
            org_api_key: '00000000-0000-4000-8000-000000000000'
          }
        end

        def video
          base.merge(
            verb: 'video_action',
            action: {
              video_id: 'http://youtube.com/?v=111111',
              session_id: 'A' * 36
            }
          )
        end

        def page
          base.merge(
            verb: 'viewed',
            action: {
              time: '356S'
            }
          )
        end

        def unprocessed
          object = send(%i(page video).sample)
        end

        def processed
          unprocessed.merge(processed_at: Time.now)
        end

        def old
          unprocessed.merge(captured_at: '01/01/2014 00:00:00')
        end

        def recent
          unprocessed
        end

        def self.raw_messages_scenario_data
          new_student_username = "newuser@novel.com"
          scenario = {
            new_student: {username: new_student_username},
            students: [joe_smith_data, bob_newhart_data],
            organization: acme_organization_data,
            raw_messages: [
              {
                username: joe_smith_data[:username],
                site_uuid: khanacademy[:site_uuid],
                verb: "viewed",
                action:
                  { time: "8M21S" },
                captured_at: 8.days.ago.iso8601,
                api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
                url: khanacademy_page1[:url]
              },
              {
                username: joe_smith_data[:username],
                site_uuid: khanacademy[:site_uuid],
                verb: "viewed",
                page_title: khanacademy_page1[:display_name],
                action:
                  { time: "12M1S" },
                captured_at: 2.days.ago.iso8601,
                api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
                url: khanacademy_page1[:url]
              },
              {
                username: joe_smith_data[:username],
                site_uuid: khanacademy[:site_uuid],
                verb: "viewed",
                action:
                  {}, # note - we don't provide value/time key for this record
                captured_at: 1.day.ago.iso8601,
                api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
                url: khanacademy_page2[:url]
              },
              {
                username: bob_newhart_data[:username],
                site_uuid: khanacademy[:site_uuid],
                verb: "viewed",
                action:
                  { time: "2M1S" },
                captured_at: 2.days.ago.iso8601,
                api_key: "2866b962-a7be-44f8-9a0c-66502fba7d31",
                url: khanacademy_page1[:url]
              },
              { # This is an org_api_key raw_message to validate that janitor handles both
                # this message refers to a known user
                username: joe_smith_data[:username],
                verb: "viewed",
                action:
                  { time: "12M24S" },
                captured_at: 4.days.ago.iso8601,
                org_api_key: acme_organization_data[:org_api_key],
                url: khanacademy_page1[:url]
              },
              {  # this message refers to a new user
                username: new_student_username,
                verb: "viewed",
                action:
                  { time: "12M24S" },
                captured_at: 4.5.days.ago.iso8601,
                org_api_key: acme_organization_data[:org_api_key],
                url: khanacademy_page1[:url]
              }
            ]
          }
        end

        require 'helpers/redis'
        include Analytics::Helpers::Redis

        def self.create_raw_message_redis_to_pg_scenario
          scenario = raw_messages_scenario_data
          # this holds username=>id associations
          usernames_ids = {}
          scenario[:students].each do |s|
            user = User.create!(s)
            usernames_ids[user.username] = user.id
          end
          Organization.create!(scenario[:organization])
          scenario[:raw_messages].each do |raw_message|
            # delete username and swap in the user_id
            # except for the org_api_key record which is supposed to have username
            if raw_message[:org_api_key].nil? then
              raw_message[:user_id]=usernames_ids[raw_message.delete(:username)]
            end
            if raw_message[:user_id].nil? && raw_message[:org_api_key].nil? then
              raise StandardError
            end
            messages_queue.push(raw_message.to_json)
          end
          scenario
        end
      end # RawMessages
    end
  end
end
