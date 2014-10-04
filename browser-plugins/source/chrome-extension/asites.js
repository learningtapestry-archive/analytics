var bg = chrome.extension.getBackgroundPage();

var site_list = document.getElementById('site_list'),
    close_page = document.getElementById('close_page'),
    sites = bg.ExtractorManager.sites.names;

close_page.addEventListener('click', function() {
    window.close();
}, false);
    
for(var i=0; i<sites.length; ++i) {
    var d = document.createElement('div');
    d.className = 'field left';
    d.textContent = sites[i].site_name;
    site_list.appendChild(d);
}
    