require 'sinatra/base'
module LT
  class WebApp < Sinatra::Base 
    def set_title(title)
      @layout[:title] = title
    end
    # set up UI options container
    # we need this to set dynamic content in the layout template
    before do
      @layout = {}
    end
    get "/" do
      set_title("Learntaculous - Knowledge for Learning")
      erb :home, :locals => {:hello_world => "Hello world"}
    end

    get "/dashboard" do
      set_title("Your Dashboard")
      erb :dashboard, :locals => {}
    end
  end
end

# Direct app example
# require 'sinatra'
# get "/" do
#   "Hello world"
# end
