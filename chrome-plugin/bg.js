/**
  * bg.js
  *
  * The main script which is always running, it manages data extraction and sending data.
  */

var _callback = function(fn, ctx) {
    return function() {
        fn.apply(ctx, arguments);
    };
};

var _map = function(a, b) {
    if(!a || !a.length) return;
    
    var m = {};
    
    if(typeof a === 'string') {
        m[a] = b;
        return m;
    }
    
    for(var i=0; i<a.length; i+=2) {
        m[a[i]] = a[i+1];
    }
    
    return m;
};

var _pad = function(num) {
    var norm = Math.abs(Math.floor(num));
    return (norm < 10 ? '0' : '') + norm;
};

var _timestamp = function() {
    var local = new Date(),
        tzo = -local.getTimezoneOffset(),
        sign = tzo >= 0 ? '+' : '-';
    return local.getFullYear() 
        + '-' + _pad(local.getMonth()+1)
        + '-' + _pad(local.getDate())
        + 'T' + _pad(local.getHours())
        + ':' + _pad(local.getMinutes()) 
        + ':' + _pad(local.getSeconds()) 
        + sign + _pad(tzo / 60) 
        + ':' + _pad(tzo % 60);
};

/**
  * ExtractorManager
  *
  * The main object which handles everything - site list and email storage, data extraction and sending data.
  */

var ExtractorManager = {
    user: null,
    sites: null,
    watching: null,
    
    user_tab: null,
    user_url: 'user.html',
    
    sites_url: 'http://finance.betaspaces.com/api/v1/user/approved-sites',
    event_url: 'http://finance.betaspaces.com/api/v1/statements/',
    
    storage_keys: {
        user: 'store_user_data',
        sites: 'store_sites_data'
    },
    
    /**
      * init
      *
      * Initializes the ExtractorManager. Looks is user already exists in storage, otherwise
      * opens page to enter email. Also looks for site list in storage, and fetches sites if
      * they are not there.
      */
    init: function() {
        chrome.browserAction.onClicked.addListener(_callback(this.getUser, this));
        
        chrome.storage.local.get([this.storage_keys.user, this.storage_keys.sites], _callback(function(o) {
            var u = this.storage_keys.user,
                s = this.storage_keys.sites;
                
            if(Object.prototype.hasOwnProperty.call(o, u) && typeof o[u] === 'string' && o[u]) {
                this.user = o[u];
            }
            else {
                this.getUser();
            }
            
            if(Object.prototype.hasOwnProperty.call(o, s) && typeof o[s] === 'string' && o[s]) {
                this.sites = new RegExp(o[s]);
                if(this.user && !this.watching) {
                    this.watch();
                }
            }
            else {
                this.getSites();
            }
        }, this));
    },
    
    /**
      * getUser
      *
      * Opens the tab to allow the user to enter their email. It maintains
      * the id of the tab in user_tab to ensure that only one tab is opened
      * for user_url at any time.
      */
    getUser: function() {     
        if(!this.user_tab) {
            chrome.tabs.create({url: this.user_url}, _callback(function(t) {
                this.user_tab = t.id;
            }, this));
            return;
        }
        
        chrome.tabs.get(this.user_tab, _callback(function(t) {
            if(!t) {
                chrome.tabs.create({url: this.user_url}, _callback(function(t) {
                    this.user_tab = t.id;
                }, this));
                return;
            }
        
            chrome.tabs.update(this.user_tab, {active: true}, _callback(function(tt) {
                this.user_tab = tt.id;
            }, this));
        }, this));
    },
    
    /**
      * setUser
      *
      * Called by the script in user_tab. Stores the email, and starts watching
      * pages if not already watching.
      *
      * It also closes the user_tab since it is no longer needed.
      */
    setUser: function(u) {
        if(typeof u !== 'string' || !u) {
            return;
        }
        
        this.user = u;
        chrome.storage.local.set(_map(this.storage_keys.user, this.user));
        
        chrome.tabs.remove(this.user_tab);
        this.user_tab = null;
        
        if(this.sites && !this.watching) {
            this.watch();
        }
    },
    
    /**
      * getSites
      *
      * Fetches approved sites' list and stores them as a RegExp.
      * Starts watching pages if user email available and not already watching.
      */
    getSites: function() {
        var r = new XMLHttpRequest, x;
        
        r.open('GET', this.sites_url, true);
        
        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {
                if(r.status === 200) {
                    x = JSON.parse(r.response)[0]['approved-sites'].join('|');
                    x = x.replace(/\//g, '\\/').replace(/\./g, '\\.').replace(/\?/g, '\\?');
                    
                    this.sites = new RegExp('^https?:\\/\\/(?:www\.)?(?:' + x + ')');
                    
                    chrome.storage.local.set(_map(this.storage_keys.sites, this.sites.source));
                    
                    if(this.user && !this.watching) {
                        this.watch();
                    }
                }
                else {
                    this.getSites();
                }
            }
        }, this);
        
        r.send();
    },
    
    /**
      * sendData
      *
      * Sends extracted data as JSON to the server.
      */
    sendData: function(ujson) {
        var r = new XMLHttpRequest();
        
        r.open('POST', this.event_url, true);
        
        r.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        r.setRequestHeader('Content-length', ujson.length);
        r.setRequestHeader('Connection', 'close');
        
        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {
                if(r.status === 200) {
                    console.log(r.response);
                }
            }
        }, this);
        
        r.send(ujson);
    },
    
    /**
      * watch
      *
      * Starts main function of ExtractorManager - watching all pages to see if
      * they match the approved sites, and running the Extractor script on them
      * if they do.
      *
      * Registers listeners to listen for events from Extractor script in each 
      * tab. Listeners populate correct JSON based on event and send it to server.
      */
    watch: function() {
        if(!this.user || !this.sites || this.watching) {
            return;
        }
        
        this.watching = true;
        
        chrome.runtime.onMessage.addListener(_callback(function(e) {
            var u = {user: null};

            if(e.t === 'pageview') {
                u.user = {
                    email: this.user,
                    action: {
                        id: 'verbs/viewed',
                        display: {
                            'en-US': 'viewed'
                        },
                        value: {
                            time: e.d.t
                        }
                    },
                    url: {
                        id: e.d.id
                    },
                    timestamp: _timestamp()
                };
            }
            else if(e.t === 'linkevent') {
                u.user = {
                    email: this.user,
                    action: {
                        id: 'verbs/clicked',
                        display: {
                            'en-US': 'clicked'
                        },
                        value: {
                            url: e.d.u
                        }
                    },
                    url: {
                        id: e.d.id
                    },
                    timestamp: _timestamp()
                };
            }
            else if(e.t === 'viewquote') {
                u.user = {
                    email: this.user,
                    action: {
                        id: 'verbs/quoted',
                        display: {
                            'en-US': 'quoted'
                        },
                        value: {
                            quote: e.d.q,
                            price: e.d.p,
                            volavg: e.d.v
                        }
                    },
                    url: {
                        id: e.d.id
                    },
                    timestamp: _timestamp()
                };
            }
            
            if(u.user) {
                this.sendData(JSON.stringify(u));
            }
        }, this));
        
        chrome.tabs.onUpdated.addListener(_callback(function(id, c, t) {
            if(c.status !== 'loading') {
                return;
            }
            
            if(this.sites.test(t.url)) {
                this.attachExtractor(id);
            }
        }, this));
    },
    
    /**
      * attachExtractor
      *
      * Attaches the Extractor script to the tab with given id.
      */
    attachExtractor: function(id) {
        chrome.tabs.executeScript(id, {file: 'extractor.js', runAt: 'document_end'}, function() {});
    }
};

ExtractorManager.init();