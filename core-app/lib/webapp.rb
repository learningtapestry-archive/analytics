require 'sinatra/base'
require 'json'
require File::join(LT::lib_path, 'util', 'session_manager.rb')

module LT
  module WebAppHelper
    def set_title(title)
      @layout[:title] = "Learntaculous - #{title}"
    end
  end # WebAppHelper
  class WebApp < Sinatra::Base 
    include WebAppHelper
    # set up UI layout container
    # we need this container to set dynamic content in the layout template
    # we can set things like CSS templates, Javascript includes, etc.
    before do
      @layout = {}
    end

    ### START Dashboard

    get "/" do
      set_title("Knowledge for Learning")
      erb :home, :locals => {:hello_world => "Hello world"}
    end

    get "/dashboard" do
      set_title("Your Dashboard")
      erb :dashboard, :locals => {}
    end

    ### END Dashboard

    ### START API

    post '/api/v1/login' do
      content_type :json
      begin
        begin
          parsed_json = JSON.parse(request.body.read)
          api_key = LT::SessionManager.validate_user(parsed_json["username"], parsed_json["password"])
          status 200
          { :status => "login success", :api_key => api_key }.to_json
        rescue Exception => e
          if e.is_a?(LT::UserNotFound) || e.is_a?(LT::PasswordInvalid) then
            status 401 # 403 = unauthorized
            { :status => 'username or password invalid' }.to_json
          elsif
            status 500
            # TODO:  Remove this after development
            { :status => e.message }.to_json
          end
        end
      end
    end # '/api/v1/login'

    get '/api/v1/logout' do
      content_type :json
      status 501
      { :status => "logged out not yet implemented" }.to_json
    end # '/api/v1/logout'

    post '/api/v1/signup' do
      content_type :json
      begin
        user = User.create_user_from_json(request.body.read)
        if user
          status 200
          # TODO: Return back API key as well
          { :status => "user created" }.to_json
        else
          status 500
          { :status => "error" }.to_json
        end
      rescue Exception => e
        status 500
        # TODO:  Remove this after development
        { :status => e.message }.to_json
      end
    end # '/api/v1/signup'

    get '/api/v1/approved_sites' do
      content_type :json
      ApprovedSiteAction.get_actions_with_sites.to_json
    end # '/api/v1/approved_sites'

    ### END API
  end
end
