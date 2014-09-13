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

# Ars Technica
approved_site = ApprovedSite.create(
  :site_name=>'Ars Technica',
  :url=>'http://arstechnica.com/'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?arstechnica\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?arstechnica\.com(/\S*)?'
)

# The Verge
approved_site = ApprovedSite.create(
  :site_name=>'The Verge',
  :url=>'http://theverge.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?theverge\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?theverge\.com(/\S*)?'
)

# Gigaom
approved_site = ApprovedSite.create(
  :site_name=>'Gigaom',
  :url=>'http://gigaom.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?gigaom\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?gigaom\.com(/\S*)?'
)

# Boing Boing
approved_site = ApprovedSite.create(
  :site_name=>'Boing Boing',
  :url=>'http://boingboing.net'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?boingboing\.net(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?boingboing\.net(/\S*)?'
)

# Washington Post
approved_site = ApprovedSite.create(
  :site_name=>'Washington Post',
  :url=>'http://washingtonpost.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?washingtonpost\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?washingtonpost\.com(/\S*)?'
)

# Stack Overflow
approved_site = ApprovedSite.create(
  :site_name=>'Stack Overflow',
  :url=>'http://stackoverflow.com'
)

approved_site.approved_site_actions.create(
  :action_type=>'CLICK',
  :url_pattern=>'http(s)?://(.*\.)?stackoverflow\.com(/\S*)?'
)

approved_site.approved_site_actions.create(
  :action_type=>'PAGEVIEW',
  :url_pattern=>'http(s)?://(.*\.)?stackoverflow\.com(/\S*)?'
)