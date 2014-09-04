/**
  * user.js
  *
  * This script manages the tab where users enter their emails. It
  * validates if proper email is entered and if email is valid, it calls 
  * ExtractorManager.setUser on submiting input.
  */

//Get the background page to access ExtractorManager.js  
var _bg = chrome.extension.getBackgroundPage();

//Regular expression used to validate entered email.
var valid_email = /[\-a-z0-9~!$%^&*_=+}{\'?]+(\.[\-a-z0-9~!$%^&*_=+}{\'?]+)*@(?:[a-z0-9_][\-a-z0-9_]*(?:\.[-a-z0-9_]+)*\.(?:aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|(?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(?:\:[0-9]{1,5})?/;

var email_input = document.getElementById('email_input'),
    save = document.getElementById('save');

var validate_email = function() {
    if(valid_email.test(email_input.value)) {
        email_input.classList.remove('invalid');
        email_input.classList.add('valid');
    }
    else {
        email_input.classList.remove('valid');
        email_input.classList.add('invalid');
    }
};
    
email_input.addEventListener('input', function() {
    validate_email();
});

//Call ExtractorManager.setUser if valid email on hitting enter.
email_input.addEventListener('keypress', function(e) {
    if(e.which !== 13) {
        return;
    }
    
    if(email_input.classList.contains('valid')) {
        _bg.ExtractorManager.setUser(email_input.value);
    }
});

//Call ExtractorManager.setUser if valid email on clicking save.
save.addEventListener('click', function(e) {
    if(e.button !== 0) {
        return;
    }
    
    if(email_input.classList.contains('valid')) {
        _bg.ExtractorManager.setUser(email_input.value);
    }
});

//If ExtractorManager already has a valid email, show it in the input field.
if(typeof _bg.ExtractorManager.user === 'string' && _bg.ExtractorManager.user) {
    email_input.value = _bg.ExtractorManager.user;
    validate_email();
}