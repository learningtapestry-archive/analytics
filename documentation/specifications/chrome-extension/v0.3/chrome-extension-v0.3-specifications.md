# Chrome Extension Specifications v0.3

# Introduction

From the originally contracted work, the following changes have been made to the extension:

* The JSON data format has been simplified and flattened for less payload, easier processing and better readability.  New field "site_uuid" added for better site tracking on the consuming end of the API.
* The approved-sites API endpoint now delivers more information on actions for each web site to be collected.  This will allow the admin end-user to select what activities they want collected from each site.  For all actions, the site_uuid tied on the backend which the admin end-user has approved.  The "url_pattern" is the RegEx string for each sites to extract from.  This all comes from the backend, but for your awareness.
*  When bg.js is called and gets the approved-site list, it calls attachExtractor for each approved-site, passing it data via _actionType with the approved-site JSON to extractor.js.
*  Changed some of the variable names for readibility on my end.

# Tasks

* Help request:  can you please look at the way I'm passing the approve-site JSON to each extractor?  Does this look appropriate way to do it?  If there is a better way, more in line with other Chrome Extensions, please refactor given your expertise.
* New feature:  Bullet - off, on, active
* New feature:  Local sync
* Bug: /api/v1/approved-sites endpoint isn't available, the plug-in will continually ping the endpoint until it reads valid JSON.  Our endpoint is crashing intermiddenly, so will need to protect against this.  In learning about this, our ideal workflow is:
* Bug:  When Chrome is first launched after install and user is not logged in, it will launch the Welcome page again.  Only launch this page once.  Gray icon if not logged in.
	* On startup, if the approved_site is found in local storage, use that.
