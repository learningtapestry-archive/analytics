# Slashdot
approved_site = ApprovedSite.create(
  :site_name=>'Slashdot',
  :site_uuid=>'658d1a95-33cb-482e-a3b1-e152ddd68c9f',
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
  :site_uuid=>'d0c33b30-72a9-40fb-abef-df3cc8a8976b',
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
  :site_uuid=>'f997b320-2a75-49d9-aba5-7c9d44d4483b',
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
  :site_uuid=>'4d22024f-94a0-443c-bb23-acdca1c0addd'
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
  :site_uuid=>'6ac95f3a-debb-4cdb-b45b-592f6f15750b',
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
  :site_uuid=>'fdb033cd-06bb-4448-b353-3110c388ffe1',
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
  :site_uuid=>'d63ea619-1a40-46eb-8ef7-f4dc00340486',
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
  :site_uuid=>'408c5f65-5311-4be7-94ee-599885715c53',
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
  :site_uuid=>'09935a32-6232-469b-aa0e-697d39fe6ed8',
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
  :site_uuid=>'136ef862-689d-412e-b3b9-dc2e1297b8d2',
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
  :site_uuid=>'2bc96317-2e9b-4288-a776-f785a2b825e0',
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