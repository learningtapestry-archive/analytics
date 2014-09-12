var _callback = function(fn, ctx) {
    return function() {
        fn.apply(ctx, arguments);
    };
};

var LoginManager = {
    bg: null,
    login: null,
    create: null,
    message: null,
    login_fields: null,
    create_fields: null,
    sign_in_btn: null,
    sign_up_btn: null,
    create_acc_btn: null,
    login_link: null,
    
    msg_to: null,
    
    login_url: 'http://localhost:8080/api/v1/login',
    create_url: 'http://localhost:8080/api/v1/signup',
    
    init: function() {
        this.bg = chrome.extension.getBackgroundPage();
        
        this.login = document.getElementById('login');
        this.create = document.getElementById('create');
        this.message = document.getElementById('message');
        
        this.login_fields = {
            username: document.getElementById('username'),
            password: document.getElementById('password')
        };
        
        this.create_fields = {
            username: document.getElementById('cr_username'),
            password: document.getElementById('cr_password'),
            first_name: document.getElementById('cr_firstname'),
            last_name: document.getElementById('cr_lastname')
        };
        
        this.sign_in_btn = document.getElementById('signin');
        this.sign_up_btn = document.getElementById('signup');
        this.create_acc_btn = document.getElementById('create_acc');
        this.login_link = document.getElementById('show_login');
        
        this.login_fields.username.value = this.bg.ExtractorManager.user || '';
        
        this.sign_in_btn.addEventListener('click', _callback(this.signIn, this));
        this.sign_up_btn.addEventListener('click', _callback(this.showCreate, this));
        this.create_acc_btn.addEventListener('click', _callback(this.createAcc, this));
        this.login_link.addEventListener('click', _callback(this.showLogin, this));
    },
    
    signIn: function() {
        this.hideMessage();
        
        if(!this.login_fields.username.value || !this.login_fields.password.value) {
            this.showMessage(0, 'Username or password not entered!');
            return;
        }
        
        var d = JSON.stringify({ 
                username: this.login_fields.username.value,
                password: this.login_fields.password.value
            }),
            r = new XMLHttpRequest(), x, y;
        
        r.open('POST', this.login_url, true);
        r.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        
        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {
                if(r.status === 200) {
                    y = JSON.parse(r.response);
                    if(y['status'] === 'login success' && y['api_key']) {
                        d = JSON.parse(d);
                        this.bg.ExtractorManager.setApi(y['api_key'], d.username, d.password);
                        window.close();
                    }
                    else {
                        this.showMessage(0, 'Username or password not found');
                    }
                }
                else {
                    this.showMessage(0, y['status']);
                }
            }
        }, this);
        
        r.send(d);
    },
    
    createAcc: function() {
        this.hideMessage();
        
        if(!this.create_fields.username.value || !this.create_fields.password.value ||
           !this.create_fields.first_name.value || !this.create_fields.last_name.value) {
            this.showMessage(0, 'All fields need to be filled!');
            return;
        }
        
        var d = JSON.stringify({ 
                username: this.create_fields.username.value,
                password: this.create_fields.password.value,
                first_name: this.create_fields.first_name.value,
                last_name: this.create_fields.last_name.value
            }),
            r = new XMLHttpRequest(), x;
        
        r.open('POST', this.create_url, true);
        
        r.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        
        r.onreadystatechange = _callback(function() {
            if(r.readyState === 4) {                
                if(r.status === 200) {
                    y = JSON.parse(r.response);
                    if(y['status'] && y['status'] === 'user created') {
                        this.showLogin();
                        this.showMessage(1, 'Created account!');
                    }
                    else {
                        this.showMessage(0, 'Please try again');
                    }
                }
                else {
                    this.showMessage(0, 'Please try again');
                }
            }
        }, this);
        
        r.send(d);
    },
    
    showCreate: function() {
        this.hideMessage();
        
        this.login.style.display = 'none';
        this.create.style.display = 'block';
    },
    
    showLogin: function() {
        this.hideMessage();
    
        this.create.style.display = 'none';
        this.login.style.display = 'block';
    },
    
    showMessage: function(t, m) {
        this.message.className = t ? 'success' : 'error';
        this.message.textContent = m;
        
        this.message.style.visibility = 'visible';
        this.message.style.opacity = 1;
        
        this.msg_to = setTimeout(_callback(function() {
            this.message.style.opacity = 0;
        }, this), 2000);
    },
    
    hideMessage: function() {
        if(this.msg_to) {
            clearTimeout(this.msg_to);
            this.msg_to = null;
        }
        
        this.message.style.visibility = 'hidden';
        this.message.style.opacity = 0;
    }
};

LoginManager.init();