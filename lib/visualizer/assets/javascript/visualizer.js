var data;

$.getJSON('/visualizer/data?range=day', function(result) {
  data = result;
  renderBarChart(data);
  renderOverview(data);
});

function renderOverview(data) {
  $('.total-visits').text(data.total_visit_count);
  $('.most-recent-visit').text(data.most_recent_visit_date);
}

function renderBarChart(data) {
  var urls = _.keys(data.recent_visits_by_page);

  var mostVisitedPage = _.max(urls, function(pageId) {
    return data.recent_visits_by_page[pageId];
  });

  var widthFactor =
    (window.innerWidth - 60) / data.recent_visits_by_page[mostVisitedPage];

  $('.page-chart-section').empty();

  var bar = d3.
    select('.page-chart-section').
    selectAll('div').
    data(urls).
    enter().
    append('div').
    style('width', function(url) {
      return (widthFactor * data.recent_visits_by_page[url]) + 'px';
    });

  bar.
    append('span').
    classed('url', true).
    text(function(url) {
      return url;
    });

  bar.
    append('span').
    classed('count', true).
    text(function(url) {
      return data.recent_visits_by_page[url];
    });
}
