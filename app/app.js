var HomeRouter = require('./apps/home/router');
require('./apps/users/router');

var App = {
  Models: {},
  Collections: {},
  Routers: {},
  start() {
    App.mainRegion = 'app';
    App.router = new HomeRouter();
    Backbone.history.start();
  },
  startSubApplication(SubApplication) {
    if (this.currentSubapp &&
        this.currentSubapp instanceof SubApplication) {
      return this.currentSubapp;
    }

    if (this.currentSubapp && this.currentSubapp.destroy) {
      this.currentSubapp.destroy();
    }

    this.currentSubapp = new SubApplication({
      region: App.mainRegion
    });

    return this.currentSubapp;
  }

}


_.extend(App, Backbone.Events);

module.exports = App;
