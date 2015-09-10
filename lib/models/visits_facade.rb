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
    {entity: params[:entity], date_range: date_range, results: structured_visits}
  end

  private

  def date_range
    params.slice(:date_begin, :date_end)
  end

  def structured_visits
    visits.group_by(&:username).map do |username, visits|
      {username: username, "#{params[:entity]}" => visit_attributes(visits)}
    end
  end

  def visits
    summary = Visit.by_dates(*(date_range.values)).by_usernames(params[:usernames]).summary(params[:entity])
    org.users.joins(:visits).merge(summary)
  end

  def visit_attributes(visits)
    visits.map { |v| v.attributes.symbolize_keys.except(:id, :username) }
  end
end