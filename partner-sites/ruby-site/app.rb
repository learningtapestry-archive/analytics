require 'sinatra'
require 'sinatra/base'
require 'sinatra/multi_route'
require 'sinatra/reloader'
require 'digest'
require 'chronic'
require 'chronic_duration'

require '../../partner-lib/ruby/lib/learning_tapestry'

class App < Sinatra::Base
  register Sinatra::MultiRoute
  use Rack::Session::Pool
  enable :sessions

  set :public_folder, 'assets'

  get '/' do
    erb :index, layout: :template
  end

  post '/' do
    if params[:username] and (params[:username].downcase == 'admin') and
       params[:password] and (Digest::MD5.hexdigest(params[:password]) == '6a369c8fc8d4e82a0ccc0b046aadd517')
      session['logged_in'] = 'true'
      redirect '/site-visits'
    else
      @message = 'Unknown username or password'
      erb :index, layout: :template
    end
  end

  route :get, :post, '/site-visits' do
    redirect '/' unless (session['logged_in'] == 'true')
    @date_begin = params[:date_begin] ? params[:date_begin] : Date.today.prev_day.strftime('%Y-%m-%d')
    @date_end = params[:date_end] ? params[:date_end] : Date.today.strftime('%Y-%m-%d')
    @type = params[:type] ? params[:type] : 'summary'

    lt_agent = LearningTapestry::Agent.new
    lt_agent.use_ssl = false

    @users = lt_agent.users
    @usernames = []
    @users[:results].each do |user|
      @usernames.push user[:username]
    end

    lt_agent.entity = 'site_visits' # or page_visits
    lt_agent.usernames = @usernames # Array of usernames
    lt_agent.add_filter :date_begin, @date_begin
    lt_agent.add_filter :date_end, @date_end
    lt_agent.type = @type
    @site_visits = lt_agent.obtain


    # Re-shape display data
    if @site_visits[:results]
      @site_visits[:results].each do |username|
        username[:site_visits].each do |site_visit|
          if site_visit[:site_name].nil? or !site_visit[:site_name].length then
            site_visit[:site_name] = site_visit[:site_domain]
          end
          site_visit[:time_active] = (site_visit[:time_active] and site_visit[:time_active] != '00:00:00') ? ChronicDuration.output(ChronicDuration.parse(site_visit[:time_active]), format: :long) : ''
        end
      end
    end

    erb :site_visits, layout: :template
  end

  route :get, :post, '/page-visits' do
    redirect '/' unless (session['logged_in'] == 'true')
    @username = params[:username]
    @date_begin = params[:date_begin] ? params[:date_begin] : Date.today.prev_day.strftime('%Y-%m-%d')
    @date_end = params[:date_end] ? params[:date_end] : Date.today.strftime('%Y-%m-%d')
    @type = params[:type] ? params[:type] : 'summary'

    lt_agent = LearningTapestry::Agent.new
    lt_agent.use_ssl = false

    lt_agent.entity = 'page_visits'
    lt_agent.usernames = [ @username ]
    lt_agent.add_filter :date_begin, @date_begin
    lt_agent.add_filter :date_end, @date_end
    lt_agent.add_filter :site_domains, params[:domain]
    lt_agent.type = @type
    @page_visits = lt_agent.obtain

    if @page_visits and @page_visits[:results] and @page_visits[:results].length > 0
      @first_name = @page_visits[:results][0][:first_name]
      @last_name = @page_visits[:results][0][:last_name]
      @site_name = @page_visits[:results][0][:page_visits][0][:site_name]
    end

    erb :page_visits, layout: :template
  end


  get '/users' do
    lt_agent = LearningTapestry::Agent.new
    lt_agent.use_ssl = false
    @users = lt_agent.users

    erb :users, layout: :template
  end

end
