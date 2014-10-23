### (C) 2014 Learning Tapestry (Hoekstra/Midgley) - All rights reserved.

require 'net/http'  #open-uri only supports GET requests

module LearningTapestry
  class Agent

    attr_accessor :api_key, :api_base, :entity, :filters
    attr_reader :response, :status

    # @filters = {} -- why doesn't this create a new hash here? same Hash.new
    @api_base = LT_API_BASE = 'https://learningtapestry.com/api/v1'
    LT_API_PATH_OBTAIN = '/obtain'

    def initialize(params={})
      @filters = {}
      @api_key = params[:api_key] if params[:api_key]
      @api_base = params[:api_base] if params[:api_base]
      @entity = params[:entity] if params[:entity]
      @filters = params[:filters] if params[:filters]
    end

    def obtain(params={})
      throw 'API key not provided or not valid' if !validate_api_key

      @entity = params[:entity] if params[:entity]
      @filters = params[:filters] if params[:filters]

      uri = URI("#{@api_base}#{LT_API_PATH_OBTAIN}")
      results = Net::HTTP.post_form(uri, data)

      @response = results.response
      @status = results.code
    end

    def add_filter(key, value)
      @filters[key] = value
    end

    def validate_api_key
      !@api_key.nil? || @api_key == /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/
    end

  end
end