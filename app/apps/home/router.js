class HomeRouter extends Backbone.Router {
  constructor(options) {
    super(options);
    this.routes = {
      '': 'showIndex'
    };
    this._bindRoutes();
  }
  showIndex() {
    var app = this.startApp();
    app.showIndex();
  }
  startApp() {
    var App = require('../../app');
    var HomeApp = require('./app');
    return App.startSubApplication(HomeApp);
  }
}

module.exports = HomeRouter;
