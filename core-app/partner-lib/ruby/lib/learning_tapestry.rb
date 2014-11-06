### (C) 2014 Learning Tapestry, Inc. - All rights reserved.

require 'net/http'
require 'uri'
require 'json'

module LearningTapestry
  class LTAgentException < Exception;end;
  class Agent
    attr_accessor :org_api_key, :org_secret_key, :api_base, :entity, :filters, :usernames, :type

    LT_API_BASE = 'https://api.learningtapestry.com'
    LT_API_PATH_OBTAIN = '/api/v1/obtain'

    #TODO: Add query token for async callers to reference their calls

    def initialize(params={})
      @api_base = params[:api_base] ? params[:api_base] : LT_API_BASE
      @filters = {}
      @usernames = []
      @org_api_key = params[:org_api_key] if params[:org_api_key]
      @org_secret_key = params[:org_secret_key] if params[:org_secret_key]
      @api_base = params[:api_base] if params[:api_base]
      @entity = params[:entity] if params[:entity]
      @filters = params[:filters] if params[:filters]
      @usernames = params[:usernames] if params[:usernames]
      @type = 'summary'
    end

    def obtain
      raise LTAgentException, 'Organization API key not provided or not valid' if !validate_org_api_key
      raise LTAgentException, 'Organization API secret not provided or not valid' if !validate_org_secret_key
      raise LTAgentException, 'Username array not provided' if !@usernames or @usernames == []
      raise LTAgentException, 'Entity type not provided' if !@entity

      params = { org_api_key: @org_api_key, org_secret_key: @org_secret_key, usernames: @usernames, entity: @entity, type: @type }
      params[:date_begin] = @filters[:date_begin] if @filters[:date_begin]
      params[:date_end] = @filters[:date_end] if @filters[:date_end]
      params[:site_domains] = @filters[:site_domains] if @filters[:site_domains]
      params[:page_urls] = @filters[:page_urls] if @filters[:page_urls]

      uri = URI("#{@api_base}#{LT_API_PATH_OBTAIN}")
      header = { 'Content-Type' => 'application/json' }
      http = Net::HTTP.new(uri.host, uri.port)
      path = '/api/v1/obtain'
      response = http.post path, params.to_json, header

      retval = JSON.parse(response.body, symbolize_names: true)
      retval[:status] = response.code.to_i

      retval
    end

    def add_filter(key, value)
      @filters[key] = value
    end

    def add_username(username)
      @usernames.push(username)
    end

    def clear_filters
      @filters = {}
    end

    def validate_org_api_key
      !@org_api_key.nil? || @org_api_key == /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}/
    end

    def validate_org_secret_key
      !@org_secret_key.nil? || @org_secret_key == /[a-f0-9]{36}/
    end

  end
end