class Page < ActiveRecord::Base
  has_many :page_visits
  belongs_to :site

  # convert URLs to their canonical representation
  # TODO currently stubbed. This should take a page
  # URL and (somehow) convert it to the canonical representation
  # This will reduce duplicate pages for the same actual page
  def self.url_to_canonical(url)
    url
  end

  # we override AR to first convert URLs to their canonical form
  def self.find_or_create_by_url(data)
    url = Page::url_to_canonical(data[:url])
    page = self.find_by_url(url)
    if page.nil?
      page = Page.new(data)
    end
    # if we don't have a display_name
    # and a new record comes with one, use it
    if !data[:display_name].nil? && page.display_name.nil? then
      page.display_name = data[:display_name]
    end

    # check if we need to create a new site
    # or associate ourselves with an existing one
    if !data[:site_id] && page.site_id.nil?
      site_url = Site::url_to_canonical(url)
      site = Site::find_or_create_by(url: site_url)
      page.site = site
    end
    page.save if page.changed?
    page
  end
end
