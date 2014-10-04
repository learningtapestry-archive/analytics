var _callback = function(fn, ctx) {
    return function() {
        fn.apply(ctx, arguments);
    };
};

var LoginManager = {
    bg: null,
    login: null,
    logout: null,
    username: null,
    login_link: null,
    logout_link: null,
    sites_link: null,
    info_link: null,
    
    msg_to: null,
    
    login_url: 'https://lt-dev01.learntaculo.us/api/v1/login',
    create_url: 'https://lt-dev01.learntaculo.us/api/v1/signup',

    //login_url: 'http://localhost:8080/api/v1/login',
    //create_url: 'http://localhost:8080/api/v1/signup',
    
    init: function() {
        this.bg = chrome.extension.getBackgroundPage();
        
        this.login = document.getElementById('login');
        this.logout = document.getElementById('logout');
        this.username = document.getElementById('username');
        
        this.login_link = document.getElementById('login_link');
        this.logout_link = document.getElementById('logout_link');
        this.sites_link = document.getElementById('sites_link');
        this.info_link = document.getElementById('info_link');

        this.login_link.addEventListener('click', _callback(this.logIn, this));
        this.logout_link.addEventListener('click', _callback(this.logOut, this));
        this.sites_link.addEventListener('click', _callback(this.showSites, this));
        this.info_link.addEventListener('click', _callback(this.showInfo, this));
        
        chrome.runtime.onMessage.addListener(_callback(function(e) {
            if(e.e === 'logged_in') {
                this.showLogout();
            }
        }, this));
        
        if(this.bg.ExtractorManager.signed) {
            this.showLogout();
        }
    },
    
    logIn: function() {
        this.bg.ExtractorManager.logIn();
    },
    
    logOut: function() {
        this.bg.ExtractorManager.logOut();
        this.showLogin();
    },
    
    showSites: function() {
        this.bg.ExtractorManager.showSites();
    },
    
    showInfo: function() {
        this.bg.ExtractorManager.showInfo();
    },
    
    showLogin: function() {
        this.logout.style.display = 'none';
        this.login.style.display = 'block';
    },
    
    showLogout: function() {
        this.username.textContent = this.bg.ExtractorManager.user.name || 'User';
        this.login.style.display = 'none';
        this.logout.style.display = 'block';
    }
};

LoginManager.init();