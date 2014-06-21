var _callback = function(fn, ctx) {
    return function() {
        fn.apply(ctx, arguments);
    };
};

var Extractor = {
    time: null,
    google_quote: /^https?:\/\/(?:www\.)?(?:google\.com\/finance\?q=.+)/,
    
    H: 3600,
    M: 60,
    
    init: function() {
        this.time = +Date.now();
        
        window.addEventListener('unload', _callback(this.pageView, this));
        
        Array.prototype.forEach.call(document.getElementsByTagName('a'), _callback(function(a) {
            if(/#.+$/.test(a.href)) {
                return;
            }
            
            a.addEventListener('click', _callback(function() {
                this.linkEvent(a.href);
            }, this));
        }, this));
        
        if(this.google_quote.test(document.location.href)) {
            this.viewQuote();
        }
    },
    
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
    
    linkEvent: function(href) {
        chrome.runtime.sendMessage({
            t: 'linkevent', 
            d: {
                u: href, 
                id: document.location.href
            }
        });
    },
    
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