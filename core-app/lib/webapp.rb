require 'sinatra/base'
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
    get "/" do
      set_title("Knowledge for Learning")
      erb :home, :locals => {:hello_world => "Hello world"}
    end

    get "/dashboard" do
      set_title("Your Dashboard")
      erb :dashboard, :locals => {}
    end
  end
end

