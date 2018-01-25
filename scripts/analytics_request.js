var page = require('webpage').create();

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

var requestUuid = uuidv4();

var startTime = Date.now();
var requestCompleteTime;

page.onConsoleMessage = function(msg) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'console: ' + msg);
};

page.onCallback = function(message) {
  if(message.visitMessageSent) {
    console.log('[' + requestUuid + ', ' + Date.now() + ']: ' +
      'visit sent to analytics server' +
      ' (duration: ' + (Date.now() - requestCompleteTime) + ')');
  }
};

page.onError = function(msg, trace) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'error: ' + msg);

  trace.forEach(function(item) {
    console.log('  ', item.file, ':', item.line);
  });
};

console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'start');

page.open('http://cobra.analytics.qa.c66.me/partner-sites/content-site/index.html', function(status) {
  console.log('[' + requestUuid + ', ' + Date.now() + ']: ' + 'request status: ' + status +
    ' (duration: ' + (Date.now() - startTime) + ')');

  requestCompleteTime = Date.now();
});
