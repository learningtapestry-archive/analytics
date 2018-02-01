var data;

$.getJSON('/visualizer/data?range=day', function(result) {
  data = result;
  renderBarChart(data);
  renderOverview(data);
});

function renderOverview(data) {
  $('.total-visits').text(data.totalVisitCount);
  $('.most-recent-visit').text(_.last(data.recentVisits).date_visited);
}

function renderBarChart(data) {
  var pageIds = _.keys(data.recentVisitsByPage);

  var mostVisitedPage = _.max(pageIds, function(pageId) {
    return data.recentVisitsByPage[pageId].length;
  });

  var widthFactor =
    (window.innerWidth - 60) / data.recentVisitsByPage[mostVisitedPage].length;

  $('.page-chart-section').empty();

  var bar = d3.
    select('.page-chart-section').
    selectAll('div').
    data(pageIds).
    enter().
    append('div').
    style('width', function(pageId) {
      return (widthFactor * data.recentVisitsByPage[pageId].length) + 'px';
    });

  bar.
    append('span').
    classed('url', true).
    text(function(pageId) {
      return _.first(data.recentVisitsByPage[pageId]).page.url;
    });

  bar.
    append('span').
    classed('count', true).
    text(function(pageId) {
      return data.recentVisitsByPage[pageId].length;
    });
}
