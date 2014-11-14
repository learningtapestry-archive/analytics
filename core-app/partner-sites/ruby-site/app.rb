require 'sinatra/base'
require 'sinatra/multi_route'
require 'sinatra/reloader'
require 'chronic'
require 'chronic_duration'

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
    lt_agent.api_base = 'https://lt-dev01.learningtapestry.com'
    lt_agent.org_api_key = 'd5dbf81c-99d9-4c26-829a-1451b0ad7813'
    lt_agent.org_secret_key = '215ef26f9f6714871e1f2e8301feca47d298c52a40003f6d9b9112115e2926c3333704d0'
    lt_agent.entity = 'site_visits' # or page_visits
    lt_agent.usernames = [ 'jason' ] # Array of usernames
    lt_agent.add_filter :date_begin, '2014-09-01'
    @site_visits = lt_agent.obtain

    # Re-shape display data
    @site_visits[:results].each do |username|
      username[:site_visits].each do |site_visit|
        if site_visit[:site_name].nil? or !site_visit[:site_name].length then
          site_visit[:site_name] = site_visit[:site_domain]
        end
        site_visit[:time_active] = ChronicDuration.output(ChronicDuration.parse(site_visit[:time_active]), format: :long) if site_visit[:time_active]
      end
    end

    #@site_visits = [ {username: 'jason@site.com', site_name: 'google.com', time: '00:40:43' } ]
    erb :dashboard, layout: :template
  end

end
