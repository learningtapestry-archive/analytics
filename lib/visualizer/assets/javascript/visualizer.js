updateOverview();
updateBarChart('day');

function updateOverview() {
  $.getJSON('/visualizer/data/overview', function(result) {
    renderOverview(result);
  });
}

function updateBarChart(range) {
  $.getJSON('/visualizer/data/visits_by_page?range=' + range, function(result) {
    renderBarChart(result);
  });
}

function renderOverview(overview) {
  $('.total-visit-count').text(overview.total_visit_count);
  $('.most-recent-visit').text(overview.most_recent_visit_date);
}

function renderBarChart(visitsByPage) {
  var urls = _.keys(visitsByPage);

  var mostVisitedPage = _.max(urls, function(pageId) {
    return visitsByPage[pageId];
  });

  var widthFactor =
    (window.innerWidth - 60) / visitsByPage[mostVisitedPage];

  $('.page-chart').empty();

  var bar = d3.
    select('.page-chart').
    selectAll('div').
    data(urls).
    enter().
    append('div').
    style('width', function(url) {
      return (widthFactor * visitsByPage[url]) + 'px';
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
      return visitsByPage[url];
    });
}

$('.time-range button').on('click', function(evt) {
  var range = $(evt.target).attr('id').slice(0, -7);

  $('.time-range button').removeClass('active');
  $(evt.target).addClass('active');

  updateBarChart(range);
});
