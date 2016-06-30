var IndexPage = require('./indexPage');


class HomeApp {
  constructor(options) {
    this.region = options.region;
  }
  
  showIndex() {
    var indexPage = this.startController(IndexPage);
    indexPage.showIndexView();
  }

  startController(Controller) {
    if (this.currentController &&
        this.currentController instanceof Controller) {
      return this.currentController;
    }

    if (this.currentController && this.currentController.destroy) {
      this.currentController.destroy();
    }

    this.currentController = new Controller({region: this.region});
    return this.currentController;
  }

}

module.exports = HomeApp;
