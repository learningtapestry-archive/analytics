#id,status,api_key,email,action,url,html,date_captured,date_created,date_updated

LT::development!
filename = File::basename(__FILE__)
tablename = filename.match(/(.*?)\./)[1]
# truncate existing data for this table
ActiveRecord::Base.connection.execute("truncate table #{tablename}")
# load test data for development
load File::expand_path(File::join(LT::Janitor::seed_path,'/test/',filename))
