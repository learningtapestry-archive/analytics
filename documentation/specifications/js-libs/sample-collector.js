// Script loader
<script>
  (function() {
    var script = document.createElement('script');
    script.src = '//remotesite.test/api/v1/collector.js?username=xxx&org_api_key=abc';
    script.async = true;
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
  })();
</script>

//loader libraries to consider:
// requirejs / labjs.com / yepnope.js

// collector.js
var lT = (function(window) {
  window.lT = {};
  //declare functions
  function main(callback) {};
  // call to load arbitrary js script files
  // pass a callback function to notify on ready
  function loadScript(url, callback) {
    var script = document.createElement('script');
    script.async = true;
    script.src = url;
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
    script.onload = script.onreadystatechange = function() {
      var rdyState = script.readyState;
      if (!rdyState || /complete|loaded/.test(script.readyState)) {
        callback();
        script.onload = null;
        script.onreadystatechange = null;
      }
    };
  };

  function useDataElements(){
    // do something with the elements loaded from js file
    lT.data_elements.element1
  }

  main(function() {
    //main code start
    loadScript('//remotesite.test/api/v1/data_elements.js?ids=8,33,49', useDataElements);
  });

  return lT;
})(window);


//loading data from server via loadScript
//this is a data script file which stuffs
//json into an lT element
//filename: /api/v1/data_elements.js?ids=8,33,49
lT.data_elements = (function (){
  return {
    element1: {col1: 'data1', col2: {'data2'}},
    element2: {col2: 'data2', col2: {'data2'}},
    element3: {col3: 'data3', col2: {'data2'}}
  };
};)();
