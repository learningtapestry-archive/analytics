# Slashdot
approved_site = ApprovedSite.create(
  :site_name=>'Slashdot',
  :url=>'http://slashdot.org'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?'
)

# TechCrunch
approved_site = ApprovedSite.create(
  :site_name=>'TechCrunch',
  :url=>'http://techcrunch.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?techcrunch\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?techcrunch\.com(/\S*)?'
)

# Gizmodo
approved_site = ApprovedSite.create(
  :site_name=>'Gizmodo',
  :url=>'http://gizmodo.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?gizmodo\.com(/\S*)?'  #Think about two urls in pattern, gizmo.do
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?gizmodo\.com(/\S*)?'
)
 
# NPR
approved_site = ApprovedSite.create(
  :site_name=>'NPR',
  :url=>'http://npr.org'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?npr\.org(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?npr\.org(/\S*)?'
)

# New York Times
approved_site = ApprovedSite.create(
  :site_name=>'New York Times',
  :url=>'http://nytimes.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?nytimes\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?nytimes\.com(/\S*)?'
)