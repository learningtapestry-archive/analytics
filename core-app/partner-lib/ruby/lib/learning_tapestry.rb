### (C) 2014 Learning Tapestry, Inc. - All rights reserved.

require 'net/http'
require 'uri'
require 'json'
require 'yaml'

module LearningTapestry
  class LTAgentException < Exception;end;
  class Agent
    attr_accessor :org_api_key, :org_secret_key, :api_base, :entity, :filters, :usernames, :type, :use_ssl

    LT_API_BASE = 'https://api.learningtapestry.com'
    LT_API_PATH_OBTAIN = '/api/v1/obtain'

    #TODO: Add query token for async callers to reference their calls

    def initialize(params={})
      @api_base = LT_API_BASE

      if !params[:ignore_config_file] and File.exists?(File.join(File.dirname(__FILE__), '../config.yml'))
        lib_config = YAML::load_file(File.join(File.dirname(__FILE__), '../config.yml'))
        @api_base = lib_config['api_base'] if lib_config['api_base']
        @org_api_key = lib_config['org_api_key'] if lib_config['org_api_key']
        @org_secret_key = lib_config['org_secret_key'] if lib_config['org_secret_key']
      end

      @api_base = params[:api_base] if params[:api_base]
      @use_ssl = params[:use_ssl].nil? ? true : params[:use_ssl]
      @org_api_key = params[:org_api_key] if params[:org_api_key]
      @org_secret_key = params[:org_secret_key] if params[:org_secret_key]
      @filters = {}
      @usernames = []
      @entity = params[:entity] if params[:entity]
      @filters = params[:filters] if params[:filters]
      @usernames = params[:usernames] if params[:usernames]
      @type = 'summary'
    end

    def obtain
      raise LTAgentException, 'Organization API key not provided or not valid' unless validate_org_api_key
      raise LTAgentException, 'Organization API secret not provided or not valid' unless validate_org_secret_key
      raise LTAgentException, 'Username array not provided' unless @usernames and @usernames != []
      raise LTAgentException, 'Entity type not provided' unless @entity

      params = { org_api_key: @org_api_key, org_secret_key: @org_secret_key, usernames: @usernames, entity: @entity, type: @type }
      params[:date_begin] = @filters[:date_begin] if @filters[:date_begin]
      params[:date_end] = @filters[:date_end] if @filters[:date_end]
      params[:site_domains] = @filters[:site_domains] if @filters[:site_domains]
      params[:page_urls] = @filters[:page_urls] if @filters[:page_urls]

      uri = URI("#{@api_base}#{LT_API_PATH_OBTAIN}")
      header = { 'Content-Type' => 'application/json' }
      http = Net::HTTP.new(uri.host, uri.port)
      if @use_ssl
        http.ssl_version = 'TLSv1'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE #TODO: not in use without client certificates
      end
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