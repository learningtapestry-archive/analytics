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
    
    init: function() {
        //chrome.storage.local.clear();
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
    
    watch: function() {
        if(!this.user || !this.sites || this.watching) {
            return;
        }
        
        this.watching = true;
        
        chrome.runtime.onMessage.addListener(_callback(function(e) {
            var u = {user: null};
            
            if(e.t === 'pageview') {
                u.user = {
                    email: 'mailto:' + this.user,
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
                    }
                };
            }
            else if(e.t === 'linkevent') {
                u.user = {
                    email: 'mailto:' + this.user,
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
                    }
                };
            }
            else if(e.t === 'viewquote') {
                u.user = {
                    email: 'mailto:' + this.user,
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
                    }
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
    
    attachExtractor: function(id) {
        chrome.tabs.executeScript(id, {file: 'extractor.js', runAt: 'document_end'}, function() {});
    }
};

ExtractorManager.init();