require 'simple_xlsx_reader'

module Analytics
  module Utils
    class RandomDataImporter
      def initialize
        @dates = parse_excel_file('dates.xlsx')
        @times = parse_excel_file('times.xlsx')
        @pages = parse_excel_file('pages.xlsx')
        @usernames = parse_excel_file('usernames.xlsx')
        @video_pages = parse_excel_file('video_pages.xlsx')
        $stdout.sync = true
      end

      def import!
        p 'Creating page visits'
        generate_page_visits
        p 'Creating video visualizations'
        generate_video_views
      end

      private
      def generate_page_visits
        1.upto(35000) do
          create_visit
          print '.'
        end
      end

      def generate_video_views
        1.upto(15000) do
          create_visualization
          print '.'
        end
      end

      def create_visit
        start_date = random_start_date
        create_page.visits.create!(user: create_user,
                                   heartbeat_id: SecureRandom.hex(36),
                                   date_visited: start_date,
                                   time_active: "#{random_time}S")
      end

      def create_visualization
        start_date = random_start_date
        end_date = random_end_date(start_date)
        create_video.visualizations.create!(user: create_user,
                                            session_id: SecureRandom.uuid,
                                            date_started: start_date,
                                            date_ended: end_date,
                                            time_viewed: Integer((end_date - start_date) * 1.day))

      end

      def create_page
        Page.find_or_create_by!(url: random_page)
      end

      def create_user
        User.find_or_create_by!(username: random_username) do |user|
          user.organization = Organization.first
        end
      end

      def create_video
        Video.find_or_create_by!(url: random_video) do |video|
          video.service_id = 'youtube'
        end
      end

      def parse_excel_file(filename)
        document = SimpleXlsxReader.open(File.join(File.dirname(__FILE__), "../../db/xlsx/staging/#{filename}"))
        document.sheets.first.rows.flatten
      end

      def random_username
        @usernames.sample
      end

      def random_page
        @pages.sample
      end

      def random_start_date
        date = @dates.sample
        time = @times.sample
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
      end

      def random_time
        rand(1..300)
      end

      def random_end_date(start_date)
        start_date + random_time.seconds
      end

      def random_video
        @video_pages.sample
      end
    end
  end
end
