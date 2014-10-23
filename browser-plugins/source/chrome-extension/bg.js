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
    signed: null,
    active: null,
    api_key: null,
    user: null,
    sites: null,
    watching: null,
    
    msg_listener: null,
    tab_listener: null,
    active_listener: null,
    
    active_tab: null,
    login_tab: null,
    asites_tab: null,
    info_tab: null,
    
    api_cookie: 'api_key',
    
    asites_url: 'asites.html',
    info_url: 'https://lt-dev01.learntaculo.us/privacy',
    welcome_url: 'https://lt-dev01.learntaculo.us/welcome',
    login_url: 'https://lt-dev01.learntaculo.us/?src=ext',
    sites_url: 'https://lt-dev01.learntaculo.us/api/v1/approved-sites',
    event_url: 'https://lt-dev01.learntaculo.us/api/v1/assert',
    
    active_icon: 'icon-active-128.png',
    on_icon: 'icon-on-128.png',
    off_icon: 'icon-off-128.png',
    
    //sites_url: 'http://localhost:8080/api/v1/approved_sites',
    //event_url: 'http://localhost:8080/api/v1/assert',

    storage_keys: {
        first: 'store_first_run',
        user: 'store_user_data',
        api_key: 'store_api_data',
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
        //chrome.storage.local.clear();
        
        chrome.cookies.onChanged.addListener(_callback(function(o) {
            if(!o.removed && o.cookie.name === this.api_cookie && o.cookie.session) {
                this.saveCreds(o.cookie.value);
            }
        }, this));
        
        chrome.storage.local.get([this.storage_keys.first, this.storage_keys.user, this.storage_keys.api_key, this.storage_keys.sites], _callback(function(o) {
            var f = this.storage_keys.first,
                a = this.storage_keys.api_key,
                u = this.storage_keys.user,
                s = this.storage_keys.sites;
            
            if(!Object.prototype.hasOwnProperty.call(o, f) || a[f]) {
                chrome.storage.local.set(_map(this.storage_keys.first, true));
                this.showWelcome();
            }
            
            if(Object.prototype.hasOwnProperty.call(o, a) && typeof o[a] === 'string' && o[a]) {
                this.api_key = o[a];
                
                if(Object.prototype.hasOwnProperty.call(o, u) && o[u]) {
                    this.user = o[u];
                }
                
                this.signed = true;
                chrome.runtime.sendMessage({e: 'logged_in', d: this.user});
                chrome.browserAction.setIcon({path: this.on_icon});
            }
            else {
                chrome.browserAction.setIcon({path: this.off_icon});
            }

            if(Object.prototype.hasOwnProperty.call(o, s) && o[s]) {
                this.sites = o[s];
                this.processSiteData();
                
                if(this.api_key && !this.watching) {
                    this.watch();
                }
            }
            else {
                this.getSites();
            }
        }, this));
    },
    
    /**
      * showWelcome
      *
      * Shows the welcome page on first installation.
      */
    showWelcome: function() {
        chrome.tabs.create({url: this.welcome_url});
    },
    
    /**
      * logIn
      *
      * Opens the login page in a new tab. If login page was already opened
      * using the popup, then makes the tab with the login page active.
      */
    logIn: function() {
        if(!this.login_tab) {
            chrome.tabs.create({url: this.login_url}, _callback(function(t) {
                this.login_tab = t.id;
            }, this));
            return;
        }
        
        chrome.tabs.get(this.login_tab, _callback(function(t) {
            if(!t) {
                chrome.tabs.create({url: this.login_url}, _callback(function(tb) {
                    this.login_tab = tb.id;
                }, this));
                return;
            }
        
            if(this.login_url !== t.url) {
                chrome.tabs.create({url: this.login_url}, _callback(function(tb) {
                    this.login_tab = tb.id;
                }, this));
                return;
            }
                
            chrome.tabs.update(this.login_tab, {active: true}, _callback(function(tt) {
                this.login_tab = tt.id;
                chrome.windows.update(tt.windowId, {focused: true});
            }, this));
        }, this));
    },
    
    /**
      * logOut
      *
      * Logs out the user by deleting all the stored data, deleting the stored api cookie,
      * and also stops watching all the sites - if watching.
      */
    logOut: function() {
        this.signed = null;
        this.api_key = null;
        this.user = null;
        
        chrome.cookies.remove({url: this.login_url, name: this.api_cookie});
        chrome.storage.local.set(_map([this.storage_keys.api_key, this.api_key, this.storage_keys.user, this.user]));
        
        chrome.browserAction.setIcon({path: this.off_icon});
        
        this.stop();
    },
    
    /**
      * showSites
      *
      * Opens a new tab with the list of approved sites obtained. If already open,
      * makes tab active.
      */
    showSites: function() {
        if(!this.asites_tab) {
            chrome.tabs.create({url: this.asites_url}, _callback(function(t) {
                this.asites_tab = t.id;
            }, this));
            return;
        }
        
        chrome.tabs.get(this.asites_tab, _callback(function(t) {
            if(!t) {
                chrome.tabs.create({url: this.asites_url}, _callback(function(tb) {
                    this.asites_tab = tb.id;
                }, this));
                return;
            }
        
            if(chrome.extension.getURL(this.asites_url) !== t.url) {
                chrome.tabs.create({url: this.asites_url}, _callback(function(tb) {
                    this.asites_tab = tb.id;
                }, this));
                return;
            }
                
            chrome.tabs.update(this.asites_tab, {active: true}, _callback(function(tt) {
                this.asites_tab = tt.id;
                chrome.windows.update(tt.windowId, {focused: true});
            }, this));
        }, this));
    },
    
    /**
      * showInfo
      *
      * Opens a new tab with the info url. If already opened using popup, 
      * makes tab active.
      */
    showInfo: function() {
        if(!this.info_tab) {
            chrome.tabs.create({url: this.info_url}, _callback(function(t) {
                this.info_tab = t.id;
            }, this));
            return;
        }
        
        chrome.tabs.get(this.info_tab, _callback(function(t) {
            if(!t) {
                chrome.tabs.create({url: this.info_url}, _callback(function(tb) {
                    this.info_tab = tb.id;
                }, this));
                return;
            }
        
            if(this.info_url !== t.url) {
                chrome.tabs.create({url: this.info_url}, _callback(function(tb) {
                    this.info_tab = tb.id;
                }, this));
                return;
            }
                
            chrome.tabs.update(this.info_tab, {active: true}, _callback(function(tt) {
                this.info_tab = tt.id;
                chrome.windows.update(tt.windowId, {focused: true});
            }, this));
        }, this));
    },
    
    /**
      * saveCreds
      *
      * Called when api cookie is detected to have been set explicitly. Extracts
      * the required values and stores them.
      *
      * Retrieves site list if not already retrieved, and starts watching.
      */
    saveCreds: function(v) {
        v = v.split('.');

        this.api_key = v[0];
        this.user = {
            id: v[1] || null,
            name: v[2] || null
        };
        
        chrome.storage.local.set(_map([this.storage_keys.api_key, this.api_key, this.storage_keys.user, this.user]));
        
        this.signed = true;
        chrome.runtime.sendMessage({e: 'logged_in', d: this.user});
        chrome.browserAction.setIcon({path: this.on_icon});
        
        if(!this.sites) {
            this.getSites();
        }
        else if(!this.watching) {
            this.watch();
        }
    },
    
    /**
      * getSites
      *
      * Fetches approved sites' list and stores them. If fetch is failed,
      * process repeats every 120 seconds until complete.
      *
      * Starts watching pages if api-key available and not already watching.
      */
    getSites: function() {
        var r = new XMLHttpRequest, x, y, z, p, q, a, b;
        
        r.open('GET', this.sites_url, true);
        
        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {
                if(r.status === 200) {
                    x = JSON.parse(r.response);
                    console.log(x);
                    y = [];
                    z = [];
                    b = '';
                    
                    for(var i=0; i<x.length; ++i) {
                        p = {}, q = x[i].site_actions;
                        for(var j=0; j<q.length; ++j) {
                            p[q[j].url_pattern] = p[q[j].url_pattern] || [];
                            p[q[j].url_pattern].push(j);
                        }
                        
                        y.push({site_name: x[i].display_name, site_uuid: x[i].site_uuid, url: x[i].url});
                        
                        for(var k in p) {
                            if(Object.prototype.hasOwnProperty.call(p, k)) {
                                a = {};
                                a.reg = k;
                                a.site_uuid = x[i].site_uuid;
                                a.actions = [];
                                for(var l=0; l<p[k].length; ++l) {
                                    a.actions.push(q[p[k][l]]);
                                }
                                z.push(a);
                                
                                b += k + '|';
                            }
                        }
                    }
                    
                    this.sites = {names: y, lookup: z, reg: b.replace(/\|$/, '')};
                    
                    chrome.storage.local.set(_map(this.storage_keys.sites, this.sites));
                    this.processSiteData();
                    
                    if(this.api_key && !this.watching) {
                        this.watch();
                    }
                }
                else {
                    setTimeout(_callback(this.getSites, this), 120999);
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
        r.setRequestHeader('Content-type', 'application/json');
        r.setRequestHeader('X-LT-API-Key', this.api_key);

        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {
                if(r.status === 200) {
                    // console.log(r.response);
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
        if(!this.api_key || !this.sites || this.watching) {
            return;
        }

        this.watching = true;
        
        this.msg_listener = _callback(function(e, s, r) {
            if(!e) {
                return;
            }
            
            var u = null;
            
            if(e.t === 'extractor_init') {
                for(var i=0; i<this.sites.lookup.length; ++i) {
                    if(this.sites.lookup[i].reg.test(e.d)) {
                        r({i: this.sites.lookup[i].site_uuid, a: this.sites.lookup[i].actions});
                        return true;
                    }
                }
            }
            else if(e.t === 'page_view') {
                u = {
                    api_key: this.api_key,
                    user_id: this.user.id,
                    site_uuid: e.d.site_uuid,
                    verb: 'viewed',
                    action: {
                        time: e.d.t
                    },
                    page_title: e.d.pt,
                    url: e.d.id,
                    captured_at: _timestamp()
                };
            }
            else if(e.t === 'click_event') {
                u = {
                    api_key: this.api_key,
                    user_id: this.user.id,
                    site_uuid: e.d.site_uuid,
                    verb: 'clicked',
                    action: {
                        url: e.d.u
                    },
                    url: e.d.id,
                    captured_at: _timestamp()
                };
            }
            else if(e.t === 'extract_event') {
                u = {
                    api_key: this.api_key,
                    user_id: this.user.id,
                    site_uuid: e.d.site_uuid,
                    verb: 'extracted',
                    action: {
                        html: e.d.html
                    },
                    url: e.d.id,
                    captured_at: _timestamp()
                };
            }
            
            if(u) {
                this.sendData(JSON.stringify(u));
            }
        }, this);
        
        this.tab_listener = _callback(function(id, c, t) {
            if(c.status !== 'loading') {
                return;
            }

            if(this.sites.reg.test(t.url)) {
                this.attachExtractor(id);
                this.active_tab = id;
                this.activated();
            }
        }, this);
        
        this.active_listener = _callback(function(t) {
            var last = this.active_tab;
            this.active_tab = t.tabId;
            chrome.tabs.get(t.tabId, _callback(function(tt) {
                if(last) {
                    chrome.tabs.sendMessage(last, {e: 'stop_page_view'});
                }
                
                if(this.sites.reg.test(tt.url)) {
                    this.activated();
                }
                else {
                    this.deactivated();
                }
			}, this));
        }, this);
        
        chrome.runtime.onMessage.addListener(this.msg_listener);
        chrome.tabs.onUpdated.addListener(this.tab_listener);
        chrome.tabs.onActivated.addListener(this.active_listener);
    },
    
    /**
      * stop
      *
      * Stops watching by removing all listeners which facilitate extraction.
      */
    stop: function() {
        if(!this.watching) {
            return;
        }
        
        this.watching = null;
        
        if(this.msg_listener) {
            chrome.runtime.onMessage.removeListener(this.msg_listener);
        }
        if(this.tab_listener) {
            chrome.tabs.onUpdated.removeListener(this.tab_listener);
        }
        if(this.active_listener) {
            chrome.tabs.onActivated.removeListener(this.active_listener);
        }
        
        this.msg_listener = null;
        this.tab_listener = null;
        this.active_listener = null;
    },
    
    /**
      * activated
      *
      * Called when tab made active is a site being watched.
      */
    activated: function() {
        if(!this.signed) {
            return;
        }
        
        chrome.tabs.sendMessage(this.active_tab, {e: 'start_page_view'});
        chrome.browserAction.setIcon({path: this.active_icon, tabId: this.active_tab});
        this.active = true;
    },
    
    /**
      * deactivated
      *
      * Called when tab made active is not a site being watched.
      */
    deactivated: function() {
        this.active = false;
        if(this.signed) {
            chrome.browserAction.setIcon({path: this.on_icon});
        }
        else {
            chrome.browserAction.setIcon({path: this.off_icon});
        }
    },
    
    /**
      * attachExtractor
      *
      * Attaches the Extractor script to the tab with given id.
      */
    attachExtractor: function(id) {
        chrome.tabs.executeScript(id, {file: 'extractor.js', runAt: 'document_end'}, function() {});
    },
    
    /**
      * processSiteData
      *
      * Converts regex strings in site data to actual RegExp objects.
      */
    processSiteData: function() {
        this.sites.reg = new RegExp(this.sites.reg);
        
        for(var i=0; i<this.sites.lookup.length; ++i) {
            this.sites.lookup[i].reg = new RegExp(this.sites.lookup[i].reg);
        }
    }
};

ExtractorManager.init();