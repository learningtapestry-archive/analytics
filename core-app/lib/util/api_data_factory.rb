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
        .group(Site.arel_table[:display_name])
        .group(Site.arel_table[:url])
        .order(User.arel_table[:username])
        .order(Site.arel_table[:display_name])

        site_visits = site_visits.where(Site.arel_table[:url].in(params[:site_domains])) if params[:site_domains]
        site_visits = site_visits.select('page_visits.date_visited::DATE as date_visited').group('page_visits.date_visited::DATE').order('date_visited') if params[:type] == 'detail'

        retval = { results: [] }
        retval[:entity] = 'site_visits'
        username = nil; username_count = -1 # (zero based array, first username add results in 0 index)
        ## Create a hash organized by username with each site visit
        site_visits.each do |site_visit|
          if username != site_visit[:username] then
            username = site_visit[:username]
            username_count += 1
            retval[:results].push({ username: username })
            retval[:results][username_count][:site_visits] = []
          end
          result_hash = {display_name: site_visit[:display_name],
                         url: site_visit[:url],
                         time_active: site_visit[:time_active]}
          result_hash[:date_visited] = site_visit[:date_visited] if params[:type] == 'detail'
          retval[:results][username_count][:site_visits].push(result_hash)
        end
        retval
      end

      def self.process_filters(params)
        params[:date_begin] = Time.now - 7.days if !params[:date_begin]
        params[:date_end] = Time.now if !params[:date_end]

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