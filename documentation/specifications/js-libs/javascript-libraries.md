==Javascript Libraries==
The javascript libraries consist of two main components:
* JS collect
* JS display

===JS Collect==
JS Collect library provides a simple mechanism to allow sites to collect data on their users. In order to function, the lib needs an organizational api_key and a username (or equiv user id).

In the html of the page where the collector is to function, there are several methods for providing the collector the data it needs to function.

====Code to borrow from Chrome Extension====
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


Collection
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

Task: build a Sinatra api route handler and controller for this collection js lib.

Sinatra route handler for /api/js/collect.js
  validate org api key is OK for this username
  org_api_key = params[:org_api_key]
  username = params[:username]
  erb :file=>include.js.erb, :include =>{:org_api_key = org_api_key, :username => username}

Task: build a javascript erb include file that has all the collection code.
ERB File include.js.erb

var org_api_key=<%=include[:org_api_key]%>;
var username=<%=include[:username]%>;

Sub-task: Response object. Build javascript code that can talk to the assert endpoint
Provide the collector response object
  Provides assert endpoint the context vars: org_api_key & username
  Can cache events as they come in, and tries to ship them off multi-threaded.

Sub-task: Collector object. Build javascript code that can collect data events on the page and communicate them to the response object.
Collector collection object
A bunch of collector code that knows how to grab:
  Arrives to new page
  Left a page (and time on that page)
  Talk to collector response object about data


== JS Display ==
```
<html>
<script include="http://lt.us/api/js/display.js?org_api_key=dkdk&username=email@email.com"
<body>

<table>
| Student name   | Grade  | Discussion | Comments | Total time this week |
   xyz              xyz       xyz          xyz     <span class="tttw">...</span>

</body>
</html>
```
