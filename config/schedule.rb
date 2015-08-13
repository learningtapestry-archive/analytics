$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require_relative 'environment'

set :environment_variable, 'RACK_ENV'
set :environment, LT.env.run_env
set :output, "#{LT.env.log_path}/lt-cron.log"

every 5.minutes do
  rake 'lt:janitors:import_raw_messages'
  rake 'lt:janitors:extract_page_visits'
  rake 'lt:janitors:extract_video_views'
end