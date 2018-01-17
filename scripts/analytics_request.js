var page = require('webpage').create();

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

var requestUuid = uuidv4();

page.onConsoleMessage = function(msg) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'console: ' + msg);
};

page.onCallback = function(message) {
  if(message.visitMessageSent) {
    console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'visit sent to analytics server, exiting');

    phantom.exit();
  }
};

page.onError = function(msg, trace) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'error: ' + msg);

  trace.forEach(function(item) {
    console.log('  ', item.file, ':', item.line);
  });
};

var startTime = Date.now();

console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'start');

page.open('http://localhost:8080/partner-sites/content-site/index.html', function(status) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'request status: ' + status);
});
