module Analytics
  module Helpers
    module Params
      #
      # Extracts filters from params for a request reporting visis
      #
      def parse_visit_params(params)
        bad_request(':usernames array not provided') unless params[:usernames]

        entity = params[:entity]
        bad_request('Entity type (entity) not provided') unless entity
        bad_request("Unknown entity: #{entity}") unless valid_entity?(entity)

        params[:type] = 'summary' unless params[:type]
        bad_request('Unknown report type') unless valid_type?(params[:type])

        params.merge!(parse_date_ranges(params))
        params[:usernames] = parse_array_param(params[:usernames])
        params[:site_domains] = parse_array_param(params[:site_domains])
        params[:page_urls] = parse_array_param(params[:page_urls])

        params
      end

      #
      # Extracts one or more properly coerced date ranges from the request params
      #
      def parse_date_ranges(params)
        dates_begin = []
        dates_end = []
        params[:date_begin] = Array(params[:date_begin])
        params[:date_end] = Array(params[:date_end])

        if params[:date_begin].empty? || params[:date_end].empty?
          dates_begin << parse_begin_date(nil)
          dates_end << parse_end_date(nil)
        else
          params[:date_begin].zip(params[:date_end]).each do |date_begin, date_end|
            dates_begin << parse_begin_date(date_begin)
            dates_end << parse_end_date(date_end)
          end
        end

        {date_begin: dates_begin, date_end: dates_end}
      end

      #
      # Converts a csv string to an array object
      #
      def parse_array_param(csv_param)
        csv_param.split(',').map(&:strip) if csv_param.present?
      end

      private

      #
      # Validates, coerces and gives a default value for date_begin parameter
      #
      def parse_begin_date(date_str)
        return 1.day.ago.utc unless date_str

        DateTime.parse(date_str)
      rescue
        bad_request('Invalid date_begin parameter')
      end

      #
      # Validates, coerces and gives a default value for date_end parameter
      #
      def parse_end_date(date_str)
        return Time.now.utc unless date_str

        parsed_date = DateTime.parse(date_str)

        date_str.size < 10 ? parsed_date.end_of_day : parsed_date
      rescue
        bad_request('Invalid date_end parameter')
      end

      private

      #
      # Checks whether its parameter is a valid report type
      #
      def valid_type?(type)
        %w(summary detail).include?(type)
      end

      #
      # Checks whether its parameter is a valid entity type
      #
      def valid_entity?(entity)
        %w(site_visits page_visits).include?(entity)
      end

      #
      # Halts the request with status 400 bad request and a custom message
      #
      def bad_request(msg)
        halt(400, json(error: msg))
      end
    end
  end
end
