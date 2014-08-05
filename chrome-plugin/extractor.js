/**
  * extractor.js
  *
  * This script is ran on each page which matches the approved sites'
  * list. It extracts data based on events.
  */
  
var _callback = function(fn, ctx) {
    return function() {
        fn.apply(ctx, arguments);
    };
};

Object.prototype.getName = function() { 
   var funcNameRegex = /function (.{1,})\(/;
   var results = (funcNameRegex).exec((this).constructor.toString());
   return (results && results.length > 1) ? results[1] : "";
};

/**
  * Extractor
  *
  * The main object of the script; handles all events and data extraction.
  */
var Extractor = {
    time: null,
    google_quote: /^https?:\/\/(?:www\.)?(?:google\.com\/finance\?q=.+)/,
    
    H: 3600,
    M: 60,
    
    /**
      * init
      * 
      * Initializes the time the page was opened, listens for unload to know
      * when page is closedm listens for clicks on all links of the page, and 
      * if the page is a Google Finance Quote, extracts quote data.
      */
    init: function() {
        var o;
        
        this.time = +Date.now();
        
        window.addEventListener('unload', _callback(this.pageView, this));
        
        Array.prototype.forEach.call(document.getElementsByTagName('a'), _callback(this.processAnchor, this));
        
        /*
         * Uses MutationObserver to look for anchor tags added/changed AFTER the script has ran.
         */
        o = new MutationObserver(_callback(function(ms) {
            ms.forEach(_callback(function(m) {
                var ns = m.addedNodes, nn;
                
                if(!ns || !ns.length) {
                    if(m.target.nodeType === 1 && m.target.tagName.toLowerCase() === 'a') {
                        this.processAnchor(m.target);
                    }
                    return;
                }
                
                for(var i=0; i<ns.length; ++i) {
                    nn = ns[i];
                    if(nn.nodeType === 1 && nn.tagName.toLowerCase() === 'a') {
                        this.processAnchor(nn);
                    }
                    else {
                      // HACK:  Figure out why exception is being thrown on extension initial load
                      try {
                        nn = nn.getElementsByTagName('a');
                        for(var j=0; j<nn.length; ++j) {
                            this.processAnchor(nn[j]);
                        }
                      } catch(err) {
                        console.log("Extractor.js error: " + err.toString());
                      }
                    }
                }
            }, this));
        }, this));
        
        o.observe(document.body, {
            childList: true,
            subtree: true,
            attributes: true,
            characterData: false
        });
        
        if(this.google_quote.test(document.location.href)) {
            this.viewQuote();
        }
    },
    
    /**
      * processAnchor
      *
      * Listens to click events on the anchor tag passed as argument.
      */
    processAnchor: function(a) {
        if(/#.+$/.test(a.href)) {
            return;
        }
            
        a.addEventListener('click', _callback(function(e) {
            this.linkEvent(a.href);
        }, this));
    },
        
    /**
      * pageView
      *
      * Called just before page is closed/navigated away from. Calculates
      * total duration for which page was open, and sends message to 
      * ExtractorManager for event 'pageview'.
      */
    pageView: function() {
        var s = '', t;
        
        this.time = Math.floor((+Date.now() - this.time)/1000);
        
        if((t = Math.floor(this.time/this.H)) > 0) {
            s += t + 'H';
            this.time = this.time % this.H;
        }
        
        if((t = Math.floor(this.time/this.M)) > 0) {
            s += t + 'M';
            this.time = this.time % this.M;
        }
        
        s += Math.floor(this.time) + 'S';
        
        chrome.runtime.sendMessage({
            t: 'pageview', 
            d: {
                t: s, 
                id: document.location.href
            }
        });
    },
    
    /**
      * linkEvent
      *
      * Called when link on page is clicked. Sends message to ExtractorManager
      * with proper link for event 'linkevent'.
      */
    linkEvent: function(href) {
        chrome.runtime.sendMessage({
            t: 'linkevent', 
            d: {
                u: href, 
                id: document.location.href
            }
        });
    },
    
    /**
      * viewQuote
      *
      * Called when page is Google Finance Quote. Extracts quote data and sends
      * it to ExtractorManager for event 'viewquote'.
      */
    viewQuote: function() {
        var q = document.location.href.match(/\?q=([^&]+)/)[1],
            p = document.querySelector('div#price-panel .pr > span'),
            v = document.querySelector('table.snap-data td.key[data-snapfield="vol_and_avg"] + td.val');
            
        if(!p || !v) {
            return;
        }
        
        chrome.runtime.sendMessage({
            t: 'viewquote', 
            d: {
                q: q, 
                p: p.textContent, 
                v: v.textContent.replace(/\s|\n|\r\n|\n\r|\r/g, ''), 
                id: document.location.href
            }
        });
    }
};

Extractor.init();