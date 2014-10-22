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

function htmlspecialchars(str) {
    return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
}

/**
  * Extractor
  *
  * The main object of the script; handles all events and data extraction.
  */
var Extractor = {
    site_uuid: null,
    time: null,
    viewing: null,    
    H: 3600,
    M: 60,
    
    /**
      * init
      * 
      * Initializes the time the page was opened, listens for unload to know
      * when page is closedm listens for clicks on all links of the page, and 
      * if the page is a Google Finance Quote, extracts quote data.
      */
    init: function(i, a) {
      this.site_uuid = i;
      var o;
      for (var i=0; i<a.length; i++) {
        if(a[i].action_type === 'CLICK') {
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
                        
                        if(!nn) {
                            continue;
                        }
                        
                        if(nn.nodeType === 1 && nn.tagName.toLowerCase() === 'a') {
                            this.processAnchor(nn);
                        }
                        else if(nn.getElementsByTagName && typeof nn.getElementsByTagName === 'function') {
                            nn = nn.getElementsByTagName('a');
                            for(var j=0; j<nn.length; ++j) {
                                this.processAnchor(nn[j]);
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
        }
        else if(a[i].action_type === 'PAGEVIEW') {
            this.time = +Date.now();
            this.viewing = true;
            
            chrome.runtime.onMessage.addListener(_callback(function(m) {
                if(m.e === 'start_page_view') {
                    if(this.viewing) {
                        return;
                    }
                    
                    this.time = +Date.now();
                    this.viewing = true;
                }
                else if(m.e === 'stop_page_view') {
                    this.pageView();
                }
            }, this));
            
            window.addEventListener('unload', _callback(this.pageView, this));
        }
        else if(a[i].action_type === 'EXTRACT') {
            this.extractEvent('body');
        }
      }
    },
    
    /**
      * processAnchor
      *
      * Listens to click events on the anchor tag passed as argument.
      */
    processAnchor: function(a, args) {
        if(/#.+$/.test(a.href)) {
            return;
        }

        a.addEventListener('click', _callback(function(e) {
            this.clickEvent(a.href);
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
        if(!this.viewing) {
            return;
        }
        
        this.viewing = null;
        
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
            t: 'page_view', 
            d: {
                site_uuid: this.site_uuid,
                t: s, 
                id: document.location.href,
                pt: document.title
            }
        });
    },
    
    /**
      * clickEvent
      *
      * Called when link on page is clicked. Sends message to ExtractorManager
      * with proper link for event 'click_event'.
      */
    clickEvent: function(href) {
        chrome.runtime.sendMessage({
            t: 'click_event', 
            d: {
                site_uuid: this.site_uuid,
                u: href, 
                id: document.location.href
            }
        });
    },
    
    extractEvent: function(cssSelector) {        
        chrome.runtime.sendMessage({
            t: 'extract_event', 
            d: {
                site_uuid: this.site_uuid,
                id: document.location.href,
                html: htmlspecialchars(document.querySelector(cssSelector).innerHTML)
            }
        });
    }
};

chrome.runtime.sendMessage({
    t: 'extractor_init', 
    d: document.location.href
}, function(r) {
    console.log(r);
    Extractor.init(r.i, r.a);
});
