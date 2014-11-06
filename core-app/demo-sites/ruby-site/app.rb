require 'sinatra/base'
require 'sinatra/multi_route'
require 'sinatra/reloader'

require '../../partner-lib/ruby/lib/learning_tapestry'

class App < Sinatra::Base

  set :public_folder, 'assets'

  get '/' do
    erb :index, layout: :template
  end

  post '/' do
    redirect '/dashboard'
  end

  get '/dashboard' do

    lt_agent = LearningTapestry::Agent.new
    lt_agent.org_api_key = '[API_KEY]'
    lt_agent.org_secret_key = '[SECRET]'
    lt_agent.entity = 'site_visits' # or page_visits
    lt_agent.usernames = [ 'joesmith@foo.com' ] # Array of usernames

    response = lt_agent.obtain
    puts response[:status]  # = HTTP status code, 200
    puts response[:results] # = data from query
    puts response[:entity] # = 'site_visits'
    puts response[:date_range] # = date begin and end range of query, default 24 hours

    erb :dashboard, layout: :template
  end

end
