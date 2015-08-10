set :environment_variable, 'RACK_ENV'
set :environment, ENV['RACK_ENV']

every 5.minutes do
  rake 'lt:janitors:import_raw_messages'
  rake 'lt:janitors:extract_page_visits'
  rake 'lt:janitors:extract_video_views'
end