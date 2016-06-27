var App = {
  Models: {},
  Collections: {},
  Routers: {},
  start() {
    _.each(_.values(this.Routers), function(Router) {
      new Router();
    })

    App.router = new DefaultRouter();
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
