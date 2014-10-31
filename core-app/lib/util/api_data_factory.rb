module LT
  module Utilities
    module APIDataFactory

      ##
      # Obtains a listing of user site_visits based on which parameters are passed in
      # usernames (in the future, add: user_ids, section_ids, teacher_id)
      #
      # :args: required:          :org_api_key
      # :args: must have one of:  :usernames
      # :args: filters:           :site_urls, :date_begin = 7 days ago, :date_end = now
      # :args: optional:          :limit = 250, :sort = 'username', 'display_date'
      #
      # :yields: JSON structure of site_visits with username, [site]_display_name, url and time_active
      #
      def self.site_visits(params = {})
        throw ParameterMissing, 'Required :org_api_key not provided' if !params[:org_api_key]
        throw ParameterMissing, 'Must have :usernames' if !params[:usernames] # Add user_ids, section_ids, teacher_id

        params[:date_begin] = Time.now - 7.days if !params[:date_begin]
        params[:date_end] = Time.now

        params[:limit] = 250 if !params[:limit] or !params[:limit].is_a? Integer
        params[:limit] = 1000 if params[:limit] > 1000

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

        retval = { results: [] }
        retval[:entity_type] = 'site_visits'
        username = nil
        username_count = -1
        ## Create a JSON structure organized by username with each site visit
        site_visits.each do |site_visit|
          if username != site_visit[:username] then
            username = site_visit[:username]
            username_count += 1
            retval[:results].push({ username: username })
            retval[:results][username_count][:site_visits] = []
          end
          array = []
          retval[:results][username_count][:site_visits].push(
              {display_name: site_visit[:display_name],
               url: site_visit[:url],
               time_active: site_visit[:time_active]})
        end
        retval
      end

      def page_visits(params = {})

      end

    end
  end
end