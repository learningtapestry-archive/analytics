require 'sinatra/base'
module LT
  class WebApp < Sinatra::Base 
    get "/" do
      "Hello world"
    end
  end
end

# Direct app example
# require 'sinatra'
# get "/" do
#   "Hello world"
# end
