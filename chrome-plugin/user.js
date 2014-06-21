var _bg = chrome.extension.getBackgroundPage();

var valid_email = /[\-a-z0-9~!$%^&*_=+}{\'?]+(\.[\-a-z0-9~!$%^&*_=+}{\'?]+)*@(?:[a-z0-9_][\-a-z0-9_]*(?:\.[-a-z0-9_]+)*\.(?:aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|(?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(?:\:[0-9]{1,5})?/;

var email_input = document.getElementById('email_input'),
    save = document.getElementById('save');
    
email_input.addEventListener('input', function() {
    if(valid_email.test(email_input.value)) {
        email_input.classList.remove('invalid');
        email_input.classList.add('valid');
    }
    else {
        email_input.classList.remove('valid');
        email_input.classList.add('invalid');
    }
});

email_input.addEventListener('keypress', function(e) {
    if(e.which !== 13) {
        return;
    }
    
    if(email_input.classList.contains('valid')) {
        _bg.ExtractorManager.setUser(email_input.value);
    }
});

save.addEventListener('click', function(e) {
    if(e.button !== 0) {
        return;
    }
    
    if(email_input.classList.contains('valid')) {
        _bg.ExtractorManager.setUser(email_input.value);
    }
});