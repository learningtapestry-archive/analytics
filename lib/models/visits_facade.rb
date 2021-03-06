#
# Simple facade that encapsulates and abstracts some of the logic required to
# query and filter the visits by entity (site|page), as well as prepare the results.
#
class VisitsFacade
  attr_reader :org, :params

  def initialize(org, params)
    @org = org
    @params = params
  end

  def results
    {
      entity: params[:entity],
      date_range: date_range,
      results: structured_visits
    }
  end

  private

  def date_range
    params.slice(:date_begin, :date_end)
  end

  def structured_visits
    retrieve_visits.group_by{ |user_visit| user_visit['username'] }.map do |username, visits|
      {
        username: username,
        "#{params[:entity]}" => visit_attributes(visits)
      }
    end
  end

  def retrieve_visits
    visits = Visit.by_dates(*(date_range.values)).by_usernames(params[:usernames])
    visits = filter_by_urls(visits)
    visits = detailed_view? ? visits.detail(params[:entity]) : visits.summary(params[:entity])
    visits = org.users.joins(:visits).merge(visits)

    ActiveRecord::Base.connection.select_all(visits.to_sql)
  end

  def filter_by_urls(visits)
    visits_to_filter = visits
    visits_to_filter = visits_to_filter.by_site_domains(params[:site_domains]) if params[:site_domains]
    visits_to_filter = visits_to_filter.by_page_urls(params[:page_urls]) if params[:page_urls] && page_entity?
    visits_to_filter
  end

  def visit_attributes(visits)
    visits.map do |v|
      v['date_visited'] = DateTime.parse(v['date_visited']) if v.has_key?('date_visited')
      v['date_left'] = DateTime.parse(v['date_left']) if v.has_key?('date_left')
      v['total_time'] = v['total_time'].to_i if v.has_key?('total_time')
      v.delete('username')
      v
    end
  end

  def detailed_view?
    params[:type] == 'detail'
  end

  def page_entity?
    params[:entity] == 'page_visits'
  end
end
