updateData('day');

function updateData(range) {
  $.getJSON('/visualizer/data?range=' + range, function(result) {
    var data = result;
    renderBarChart(data);
    renderOverview(data);
  });
}

function renderOverview(data) {
  $('.total-visit-count').text(data.total_visit_count);
  $('.most-recent-visit').text(data.most_recent_visit_date);
}

function renderBarChart(data) {
  var urls = _.keys(data.recent_visits_by_page);

  var mostVisitedPage = _.max(urls, function(pageId) {
    return data.recent_visits_by_page[pageId];
  });

  var widthFactor =
    (window.innerWidth - 60) / data.recent_visits_by_page[mostVisitedPage];

  $('.page-chart').empty();

  var bar = d3.
    select('.page-chart').
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

$('.time-range button').on('click', function(evt) {
  var range = $(evt.target).attr('id').slice(0, -7);

  $('.time-range button').removeClass('active');
  $(evt.target).addClass('active');

  updateData(range);
});
