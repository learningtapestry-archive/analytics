# Slashdot
approved_site = ApprovedSite.create(
  :site_name=>'Slashdot',
  :site_hash=>'27c74d4da0789bd3557b0a82aea8c759',
  :url=>'http://slashdot.org'
)

  approved_site.approved_site_actions.create(
    :action_type=>'CLICK',
    :url_pattern=>'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?',
  )

  approved_site.approved_site_actions.create(
    :action_type=>'PAGEVIEW',
    :url_pattern=>'http(s)?://(.*\.)?slashdot\.(com|org)(/\S*)?'
  )

# TechCrunch
approved_site = ApprovedSite.create(
  :site_name=>'TechCrunch',
  :site_hash=>'8c63e4e9beb90b0a9ca92e896be646da',
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
  :site_hash=>'42e735bbfcc00757ceb03b632000a02a',
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
  :url=>'http://npr.org',
  :site_hash=>'9688ad746cea4c437212d0ac2754e787'
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
  :site_hash=>'4fe2a48a3c9cca2f7aacbc429d084754',
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
  :site_hash=>'52a7dafb049f85c047892807e1f51a1a',
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
  :site_hash=>'b49cf44e0129364982a8e98a54067539',
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
  :site_hash=>'6656dd67a96a23bd7e2e508e30e9705b',
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
  :site_hash=>'2c314552cef288e21cbd3f1490016b62',
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
  :site_hash=>'2c9f88c048870e837bc3ec1e5090419d',
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
  :site_hash=>'4f5978b72bf7f778629886a575375ba6',
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