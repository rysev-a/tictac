var HomeView = require('./views/homeView')

class Indexpage {
  constructor(options) {
    this.region = options.region;
    _.extend(this, Backbone.Events);
  }
  showIndexView() {
    var element = React.createElement(HomeView)
    ReactDOM.render(element, document.getElementById(this.region));
  }
}

module.exports = Indexpage;
