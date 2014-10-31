// Display code strategies
/*

1. Partner code runs entirely on their server
  * Integrates to LT via https/pre-shared secret
  * Strategies: Run code async to partner's render process
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


*/





// Script loader
<script>
  (function() {
    var script = document.createElement('script');
    script.src = '//remotesite.test/api/v1/collector.js?username=xxx&org_api_key=abc';
    script.async = true;
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
  })();
</script>

//loader libraries to consider:
// requirejs / labjs.com / yepnope.js

// collector.js
var lT = (function(window) {
  window.lT = {};
  //declare functions
  function main(callback) {};
  // call to load arbitrary js script files
  // pass a callback function to notify on ready
  function loadScript(url, callback) {
    var script = document.createElement('script');
    script.async = true;
    script.src = url;
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
    script.onload = script.onreadystatechange = function() {
      var rdyState = script.readyState;
      if (!rdyState || /complete|loaded/.test(script.readyState)) {
        callback();
        script.onload = null;
        script.onreadystatechange = null;
      }
    };
  };

  function useDataElements(){
    // do something with the elements loaded from js file
    lT.data_elements.element1
  }

  main(function() {
    //main code start
    loadScript('//remotesite.test/api/v1/data_elements.js?ids=8,33,49', useDataElements);
  });

  return lT;
})(window);


// xsrf tokens (third party?)
// referer domain verification


// easyxdm
// cross domain messaging interface

//loading data from server via loadScript
//this is a data script file which stuffs
//json into an lT element
//filename: /api/v1/data_elements.js?ids=8,33,49
lT.data_elements = (function (){
  return {
    element1: {col1: 'data1', col2: {'data2'}},
    element2: {col2: 'data2', col2: {'data2'}},
    element3: {col3: 'data3', col2: {'data2'}}
  };
};)();


// CORS compatible browser request method
function makeCORSRequest(url, method) {
  if (typeof XMLHttpRequest === "undefined") {
    return null;
  }
  var xhr = new XMLHttpRequest();
    if ("withCredentials" in xhr) {
    xhr.open(method, url, true);
  } else if (typeof XDomainRequest !== "undefined") {
    xhr = new XDomainRequest();
    xhr.open(method, url);
  } else {
    xhr = null;
  }
  return xhr;
}

// jquery plugin to support ie8/9 CORS calls in JQuery
// https://github.com/dkastner/jquery.iecors
// on web page: 
<!--[if lt IE 10]>
<!--iecors provides a jQuery ajax custom transport for IE8/9 XDR-->
<script src="scripts/jquery.iecors.js"></script>
<![endif]-->

// file jquery.iecors.js:
(function( jQuery ) {
  // Create the request object
  // (This is still attached to ajaxSettings for backward compatibility)
  jQuery.ajaxSettings.xdr = function() {
    return (window.XDomainRequest ? new window.XDomainRequest() : null);
  };

  // Determine support properties
  (function( xdr ) {
    jQuery.extend( jQuery.support, { iecors: !!xdr });
  })( jQuery.ajaxSettings.xdr() );

  // Create transport if the browser can provide an xdr
  if ( jQuery.support.iecors ) {

    jQuery.ajaxTransport(function( s ) {
      var callback,
        xdr = s.xdr();

      return {
        send: function( headers, complete ) {
          xdr.onload = function() {
            var headers = { 'Content-Type': xdr.contentType };
            complete(200, 'OK', { text: xdr.responseText }, headers);
          };
          
          // Apply custom fields if provided
          if ( s.xhrFields ) {
            xhr.onerror = s.xhrFields.error;
            xhr.ontimeout = s.xhrFields.timeout;
          }

          xdr.open( s.type, s.url );

          // XDR has no method for setting headers O_o

          xdr.send( ( s.hasContent && s.data ) || null );
        },

        abort: function() {
          xdr.abort();
        }
      };
    });
  }
})( jQuery );

 
// alt code to support ie8/9 CORS calls in JQuery
// https://github.com/jaubourg/ajaxHooks/blob/master/src/xdr.js
if ( window.XDomainRequest ) {
  jQuery.ajaxTransport(function( s ) {
    if ( s.crossDomain && s.async ) {
      if ( s.timeout ) {
        s.xdrTimeout = s.timeout;
        delete s.timeout;
      }
      var xdr;
      return {
        send: function( _, complete ) {
          function callback( status, statusText, responses, responseHeaders ) {
            xdr.onload = xdr.onerror = xdr.ontimeout = jQuery.noop;
            xdr = undefined;
            complete( status, statusText, responses, responseHeaders );
          }
          xdr = new XDomainRequest();
          xdr.onload = function() {
            callback( 200, "OK", { text: xdr.responseText }, "Content-Type: " + xdr.contentType );
          };
          xdr.onerror = function() {
            callback( 404, "Not Found" );
          };
          xdr.onprogress = jQuery.noop;
          xdr.ontimeout = function() {
            callback( 0, "timeout" );
          };
          xdr.timeout = s.xdrTimeout || Number.MAX_VALUE;
          xdr.open( s.type, s.url );
          xdr.send( ( s.hasContent && s.data ) || null );
        },
        abort: function() {
          if ( xdr ) {
            xdr.onerror = jQuery.noop;
            xdr.abort();
          }
        }
      };
    }
  });
}


// more reference on IE8/9 and cors
// http://mcgivery.com/ie8-and-cors/


// javascript sdk
(function(window, undefined) {
  var Stork = {};
  if (window.Stork) {
    return;
  }
  function loadScript(callback) {}
  Stork.init = function(callback) {
    loadScript('http://camerastork.com/sdk/lib.js', callback);
  };
  window.Stork = Stork;
})(this);

