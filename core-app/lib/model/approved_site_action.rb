class ApprovedSiteAction < ActiveRecord::Base
  belongs_to :approved_site

  def self.get_actions_with_sites
    connection = ActiveRecord::Base.connection

    sql = <<END 
                SELECT sites.site_name,sites.url,sites.site_hash,actions.action_type,actions.url_pattern,actions.css_selector 
                FROM approved_site_actions actions
                LEFT JOIN approved_sites sites 
                ON sites.id = actions.approved_site_id
END

    results = connection.execute sql
    result_array ||= Array.new

    results.each do |row|
      result_array.push(row)
    end

    result_array
  end

end
