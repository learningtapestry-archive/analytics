var pageIds = _.keys(data.visitsByPage);

var bar = d3.
  select('.page-chart').
  selectAll('div').
  data(pageIds).
  enter().
  append('div').
  style('width', function(pageId) {
    return (30 * data.visitsByPage[pageId].length) + 'px';
  });

bar.
  append('span').
  classed('url', true).
  text(function(pageId) {
    return _.first(data.visitsByPage[pageId]).page.url;
  });

bar.
  append('span').
  classed('count', true).
  text(function(pageId) {
    return data.visitsByPage[pageId].length;
  });
