/* globals data */

var pageIds = _.keys(data.recentVisitsByPage);

var mostVisitedPage = _.max(pageIds, function(pageId) {
  return data.recentVisitsByPage[pageId].length;
});

var widthFactor =
  (window.innerWidth - 60) / data.recentVisitsByPage[mostVisitedPage].length;

var bar = d3.
  select('.page-chart').
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
