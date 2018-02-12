require 'ffaker'

def connection
  ActiveRecord::Base.connection
end

def create_organization(options = {})
  connection.insert_sql("INSERT INTO organizations (name, org_api_key, org_secret_key) VALUES('#{options[:name]}', '#{options[:org_api_key]}', '#{options[:org_secret_key]}')")
end

def create_site(options = {})
  connection.insert_sql("INSERT INTO sites (url, site_uuid) VALUES('#{options[:url]}', '#{options[:site_uuid]}')")
end

def create_user(options = {})
  connection.insert_sql("INSERT INTO users (username, organization_id) VALUES('#{options[:username]}', #{options[:organization_id]})")
end

def create_page(options = {})
  connection.insert_sql("INSERT INTO pages (site_id, url) VALUES(#{options[:site_id]}, '#{options[:url]}')")
end

def create_visit(options = {})
  connection.insert_sql("INSERT INTO visits (user_id, page_id, time_active, date_visited, heartbeat_id) VALUES(#{options[:user_id]}, #{options[:page_id]}, #{options[:time_active]}, '#{options[:date_visited]}', '#{options[:heartbeat_id]}')")
end

namespace :generate do
  desc 'Generate a new organization with visits for stress testing'
  task :visits, [:users_count, :daily_visits_count] => :'lt:boot' do |t, args|
    USERS_COUNT = args[:users_count] || 30
    SITES_COUNT = 3
    DAILY_VISITS_COUNT = args[:daily_visits_count] || 40
    DATE_BEGIN = 3.months.ago.to_date

    ActiveRecord::Base.transaction do
      org_id = create_organization(
        name: FFaker::Company.name,
        org_api_key: SecureRandom.uuid,
        org_secret_key: SecureRandom.uuid
      )
      puts "Organization id #{org_id}"

      site_ids = []
      SITES_COUNT.times do
        id = create_site url: FFaker::Internet.domain_name, site_uuid: SecureRandom.uuid
        site_ids << id
      end

      user_ids = []
      USERS_COUNT.times do
        id = create_user(
          username: FFaker::Internet.user_name,
          organization_id: org_id
        )
        user_ids << id
      end

      page_ids = (site_ids * 10).map do |site_id|
        create_page(
          site_id: site_id,
          url: "#{FFaker::Internet.http_url}/#{FFaker::Lorem.word}.html"
        )
      end

      visits = []
      added = 0
      total = (Date.today.mjd - DATE_BEGIN.mjd) * USERS_COUNT * DAILY_VISITS_COUNT

      date = DATE_BEGIN
      while date < Time.now
        date += 1.day

        user_ids.each do |user_id|
          DAILY_VISITS_COUNT.times do
            visits << create_visit(
              user_id: user_id,
              page_id: page_ids.sample,
              time_active: rand * 1000,
              date_visited: date,
              heartbeat_id: SecureRandom.hex(36)
            )
          end
        end

        added += USERS_COUNT * DAILY_VISITS_COUNT

        puts "Processed #{added}/#{total} visits"
      end

      puts "Created #{visits.count} visits"
    end
  end
end
