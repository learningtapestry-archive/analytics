#
# Functionality to report objects by number of visits, like a web site, a web
# page or a web subdomain.
#
# The class including this needs to be an ActiveRecord object with `url` and
# `display_name` columns and has to implement an adapter class method
# `join_visits to tell `Summarizable` how to join the object with the `visits`
# table.
#
# TODO: DRY up tests. The summarize method is tested in all the modules
# including `Sumarizable` and the code is almost the same. Probably the best
# solution is to test the Summarizable module in isolation.
#
# TODO: Expand the `summary` tests. Right now they only test that the correct
# number of records is returned and this is probably the most complicated stuff
# in the app currently.
#
module Summarizable
  def summary(user, opts = {})
    select = <<-SQL
      SELECT display_name, url, time
      FROM (#{grouped_summary(user, opts).to_sql}) summary
      ORDER BY time DESC
    SQL

    find_by_sql(select)
  end

  def base_grouped_summary(user, opts = {})
    from = opts[:begin_date] || 1.week.ago.to_date
    to = opts[:end_date] || Time.now.to_date

    select("#{selected_cols}, sum(time_active) as time")
      .join_visits
      .where(visits: { user_id: user.id })
      .where("visits.date_visited BETWEEN '#{from}' and '#{to}'")
      .group(selected_cols)
  end

  def selected_cols
    "#{table_name}.display_name, #{table_name}.url"
  end
end
