### (C) 2014 Learning Tapestry, Inc. - All rights reserved.

require 'net/http'
require 'uri'
require 'json'

module LearningTapestry
  class Agent
    attr_accessor :org_api_key, :api_base, :entity, :filters, :usernames

    LT_API_BASE = 'https://api.learningtapestry.com'
    LT_API_PATH_OBTAIN = '/api/v1/obtain'

    #TODO: Add query token for async callers to reference their calls

    def initialize(params={})
      @api_base = params[:api_base] ? params[:api_base] : LT_API_BASE
      @filters = {}
      @usernames = []
      @org_api_key = params[:org_api_key] if params[:org_api_key]
      @api_base = params[:api_base] if params[:api_base]
      @entity = params[:entity] if params[:entity]
      @filters = params[:filters] if params[:filters]
      @usernames = params[:usernames] if params[:usernames]
    end

    def obtain
      throw 'Organization API key not provided or not valid' if not validate_org_api_key
      throw 'Username list not provided' if not @usernames

      data = { org_api_key: @org_api_key, usernames: @usernames, filters: @filters }.to_json

      uri = URI("#{@api_base}#{LT_API_PATH_OBTAIN}")
      header = { 'Content-Type' => 'application/json' }
      http = Net::HTTP.new(uri.host, uri.port)
      path = '/api/v1/obtain'
      response = http.post path, data, header

      retval = {}
      retval[:status] = response.code.to_i
      retval[:data] = JSON.parse(response.body, symbolize_names: true)

      retval
    end

    def add_filter(key, value)
      @filters[key] = value
    end

    def add_username(username)
      @usernames.push(username)
    end

    def validate_org_api_key
      !@org_api_key.nil? || @org_api_key == /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/
    end

  end
end