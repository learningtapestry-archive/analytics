module LT
  module Utilities
    module APIDataFactory

      ## Design TODO:  Think about limits, offsets/paging.  Don't
      # think now can provide that as would present a subset of
      # reporting data, but may be desired either internally or by parnter
      # to limit data payload.  Think about sorting as well.

      ##
      # Obtains a listing of user site_visits based on which parameters are passed in
      # usernames (in the future, add: user_ids, section_ids, teacher_id)
      #
      # :args: required:          :org_api_key
      # :args: must have one of:  :usernames
      # :args: filters:           :site_domains, :date_begin = 7 days ago, :date_end = now
      # :args: optional:          :type = 'summary', 'detail' - summary default, detail returning dates
      #
      # :yields: Hash structure of site_visits with username, [site]_display_name, url and time_active
      #
      def self.site_visits(params = {})
        throw ParameterMissing, 'Required :org_api_key not provided' if !params[:org_api_key]
        throw ParameterMissing, 'Must provide :usernames' if !params[:usernames] # Add user_ids, section_ids, teacher_id

        params = process_filters(params)

        site_visits = Site
        .select(User.arel_table[:username])
        .select(User.arel_table[:first_name])
        .select(User.arel_table[:last_name])
        .select(Site.arel_table[:display_name])
        .select(Site.arel_table[:url])
        .select(PageVisit.arel_table[:time_active].sum.as('time_active'))
        .joins('JOIN pages ON pages.site_id = sites.id')
        .joins('JOIN page_visits ON page_visits.page_id = pages.id')
        .joins('JOIN users ON users.id = page_visits.user_id')
        .joins('JOIN organizations ON organizations.id = users.organization_id')
        .where(['organizations.org_api_key = ?', params[:org_api_key]])
        .where(['page_visits.date_visited BETWEEN SYMMETRIC ? and ?', params[:date_begin], params[:date_end]])
        .where(User.arel_table[:username].in(params[:usernames]))
        .group(User.arel_table[:username])
        .group(User.arel_table[:first_name])
        .group(User.arel_table[:last_name])
        .group(Site.arel_table[:display_name])
        .group(Site.arel_table[:url])
        .order(User.arel_table[:username])
        .order(Site.arel_table[:display_name])

        site_visits = site_visits.where(Site.arel_table[:url].in(params[:site_domains])) if params[:site_domains]
        site_visits = site_visits.select('page_visits.date_visited::DATE as date_visited').group('page_visits.date_visited::DATE').order('date_visited') if params[:type] == 'detail'

        retval = { results: [] }
        retval[:entity] = 'site_visits'
        retval[:date_range] = {}
        retval[:date_range][:date_begin] = params[:date_begin]
        retval[:date_range][:date_end] = params[:date_end]

        username = nil; username_count = -1 # (zero based array, first username add results in 0 index)
        ## Create a hash organized by username with each site visit
        site_visits.each do |site_visit|
          if username != site_visit[:username] then
            username = site_visit[:username]
            username_count += 1
            retval[:results].push({ username: username, first_name: site_visit[:first_name], last_name: site_visit[:last_name] })
            retval[:results][username_count][:site_visits] = []
          end
          result_hash = {site_name: site_visit[:display_name],
                         site_domain: site_visit[:url],
                         time_active: site_visit[:time_active]}
          result_hash[:date_visited] = site_visit[:date_visited] if params[:type] == 'detail'
          retval[:results][username_count][:site_visits].push(result_hash)
        end
        retval
      end

      def self.page_visits(params = {})
        throw ParameterMissing, 'Required :org_api_key not provided' if !params[:org_api_key]
        throw ParameterMissing, 'Must have :usernames' if !params[:usernames] # Add user_ids, section_ids, teacher_id

        params = process_filters(params)

        page_visits = Site
        .select(User.arel_table[:username])
        .select(User.arel_table[:first_name])
        .select(User.arel_table[:last_name])
        .select(Site.arel_table[:display_name].as('site_name'))
        .select(Page.arel_table[:display_name].as('page_name'))
        .select(Site.arel_table[:url].as('site_domain'))
        .select(Page.arel_table[:url].as('page_url'))
        .select(PageVisit.arel_table[:time_active].sum.as('time_active'))
        .joins('JOIN pages ON pages.site_id = sites.id')
        .joins('JOIN page_visits ON page_visits.page_id = pages.id')
        .joins('JOIN users ON users.id = page_visits.user_id')
        .joins('JOIN organizations ON organizations.id = users.organization_id')
        .where(['organizations.org_api_key = ?', params[:org_api_key]])
        .where(['page_visits.date_visited BETWEEN SYMMETRIC ? and ?', params[:date_begin], params[:date_end]])
        .where(User.arel_table[:username].in(params[:usernames]))
        .group(User.arel_table[:username])
        .group(User.arel_table[:first_name])
        .group(User.arel_table[:last_name])
        .group(Site.arel_table[:display_name])
        .group(Page.arel_table[:display_name])
        .group(Site.arel_table[:url])
        .group(Page.arel_table[:url])
        .order(User.arel_table[:username])
        .order(Site.arel_table[:display_name])

        page_visits = page_visits.where(Site.arel_table[:url].in(params[:site_domains])) if params[:site_domains]
        page_visits = page_visits.where(Page.arel_table[:url].in(params[:page_urls])) if params[:page_urls]
        page_visits = page_visits.select('page_visits.date_visited').group('page_visits.date_visited').order('date_visited') if params[:type] == 'detail'

        retval = { results: [] }
        retval[:entity] = 'page_visits'
        retval[:date_range] = {}
        retval[:date_range][:date_begin] = params[:date_begin]
        retval[:date_range][:date_end] = params[:date_end]

        username = nil; username_count = -1 # (zero based array, first username add results in 0 index)
        ## Create a hash organized by username with each site visit
        page_visits.each do |page_visit|
          if username != page_visit[:username]
            username = page_visit[:username]
            username_count += 1
            retval[:results].push({ username: username, first_name: page_visit[:first_name], last_name: page_visit[:last_name] })
            retval[:results][username_count][:page_visits] = []
          end
          result_hash = {site_name: page_visit[:site_name],
                         site_domain: page_visit[:site_domain],
                         page_name: page_visit[:page_name],
                         page_url: page_visit[:page_url],
                         time_active: page_visit[:time_active]}
          result_hash[:date_visited] = page_visit[:date_visited] if params[:type] == 'detail'
          retval[:results][username_count][:page_visits].push(result_hash)
        end
        retval
      end

      def self.users(org_api_key, org_secret_key)
        throw ParameterMissing, 'Required org_api_key and org_secret_key not provided' unless org_api_key and org_secret_key

        retval = {}
        org = Organization.find_by_org_api_key(org_api_key)
        # TODO Security: Organization should take care of being locked internally
        #   -- the .verify_secret method should check self.locked
        if org.nil? or org.locked or !org.verify_secret(org_secret_key)
          retval[:error] = 'org_api_key invalid or locked'
          retval[:status] = 401
        else
          # TODO: Jason check this line - is this always a 200 response?
          retval[:status] = 200
          retval[:results] = org.users.select(:id, :first_name, :last_name, :username).order(:username)
        end

        retval
      end


      def self.process_filters(params)

        ## Ensure we have valid dates specified.  If date range not specified
        ## default date begin on 24 hours from now and date end on now.
        ## If user specifies date, ensure they are valid format or throw
        ## exception with error message.

        params[:date_begin] = DateTime.now - 1.days if !params[:date_begin]
        begin
          params[:date_begin] = DateTime.parse params[:date_begin] if !params[:date_begin].is_a? DateTime
        rescue
          throw InvalidParameter, 'Invalid begin date specified'
        end

        params[:date_end] = Time.now if !params[:date_end]
        begin
          ## If the end date string doesn't have a time component, add last second of date to expand full intended range
          params[:date_end] += 'T23:59:59' if params[:date_end].is_a? String and params[:date_end].length <= 10 and params[:date_end].length > 0
          params[:date_end] = DateTime.parse params[:date_end] if !params[:date_begin].is_a? DateTime
        rescue
          throw InvalidParameter, 'Invalid end date specified'
        end

        params[:type] = 'summary' if !params[:type] and !params[:type].to_s.downcase != 'detail'

        ## TODO: Design note as specified at top of module
        #params[:limit] = 250 if !params[:limit] or !params[:limit].is_a? Integer
        #params[:limit] = 1000 if params[:limit] > 1000
        #params[:offset] = 1 if !params[:offset] or !params[:offset].is_a? Integer

        params
      end

    end
  end
end