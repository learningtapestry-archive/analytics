module Analytics
  module Utils
    module Scenarios
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

      module RawMessages
        include Pages

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
            },
            heartbeat_id: SecureRandom.hex(36)
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
      end
    end
  end
end
