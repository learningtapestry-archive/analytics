#Javascript Libraries
The javascript libraries consist of two main components:
* JS collector
* JS display

##JS Collector
JS Collect library provides a simple mechanism to allow sites to collect data on their users. In order to function, the lib needs an organizational api_key and a username (or equiv user id).

In the html of the page where the collector is to function, there are several methods for providing the collector the data it needs to function.

###Code to borrow from Chrome Extension
* bg.js: background process of plugin/extension. This talks to assert endpoint. It also conversts extractor.js payload format events into raw_message format before sending.
  * lines 438-452 - raw message formatting
  * sendData function - post to assert api endpoint (line 388)
    * Use special x-lt-api-key header, format application/json mimetype
* extractor.js: Monitor pages for event and creates a payload format event which is handed to bg.js
  * init: i = site uuid; a = site action description (see approved sites format)
  * Line 85: pageview registration event - includes timer
    * window.unload - stop timer + page view event w/time on page
    * window.focus - restart timer
    * window.blur - pause timer
    * window.load - load page event + start timer
  * Line 133: Page view event function. Message is lines 156-163

Rack changes header:
"X-LT-API-Key" to "HTTP_X_LT_API_KEY"


Collection methods:

```
<html>
<!--method 1: provide all data in js include-->
<script include="http://lt.us/api/js/collect.js?org_api_key=dkdk&username=email@email.com" />
<body>
<!--method 2: provide org_api_key in js include, provide username in special javascript field-->
<script>
  var ltOrgUsername="email@email.com";
</script>
<!--method 3: provide information about DOM element that can be scrapped for username-->
<span class="username">
  username: public@misuse.org
</span>

</body>
</html>
```

In order for these methods to function the javascript include file needs to be dynamic.

* Task: build a Sinatra api route handler and controller for this collection js lib.

** Sinatra route handler for /api/js/collect.js
*** validate org api key is OK for this username
*** org_api_key = params[:org_api_key]
*** username = params[:username]
*** erb :file=>include.js.erb, :include =>{:org_api_key = org_api_key, :username => username}

*Task: build a javascript erb include file that has all the collection code.
ERB File include.js.erb
```
var org_api_key=<%=include[:org_api_key]%>;
var username=<%=include[:username]%>;
```

**Sub-task: Response object. Build javascript code that can talk to the assert endpoint
*** Provide the collector response object
**** Provides assert endpoint the context vars: org_api_key & username
**** Can cache events as they come in, and tries to ship them off multi-threaded.

** Sub-task: Collector object. Build javascript code that can collect data events on the page and communicate them to the response object.
*** Collector collection object
*** A bunch of collector code that knows how to grab:
**** Arrives to new page
**** Left a page (and time on that page)
**** Talk to collector response object about data


## JS Display
### Display code API strategies

1. Partner code runs entirely on their server
  * Integrates to LT via https/pre-shared secret
  * Downside: Synchronous - delays partner page generation
  * Downside: Have to implement libraries for major languages
    * Have to implement display data access for each language
  * Upside: Easy to write and test. Unlikely to break.

2. HMAC/OAuth key generation entirely local to partner server
  * LT JS lib uses HMAC key to gain access to user data in our api
  * Downside: Have to maintain multi-platform codebases
  * Downside: Have to implement tricky security code
  * Downside: Have to author javascript display library
  * Upside: No net access, very fast

3. HMAC key generation provided as a service to partner server
  * Partner server calls LT with pre-shared secret & username to hmac api endpoint
  * LT responds with HMAC token valid for that user
  * Downside: Synchronous - delays partner page generation
  * Downside: Have to implement tricky security code
  * Downside: Have to implement libraries for major languages (but library is simple)
  * Downside: Have to author javascript display library
  * Upside: Shorter network delay than Item 1 (prob 200ms vs 400ms for #1)


### Semi-deprecated strategies
Proposed technique is to use a single javascript include to specify the user and the api key.

Then inside the html, by setting a particular class variable, data can be pulled into the page for a given user.
```
<html>
<script include="http://lt.us/api/js/display.js?org_api_key=dkdk&username=email@email.com"
<body>

<table>
| Student name   | Grade  | Discussion | Comments | Total time this week |
   xyz              xyz       xyz          xyz     <span class="lt-data" ltuser="public@misuse.org" ltdata="totaltime-allpages-week">...</span>

</body>
</html>
```
