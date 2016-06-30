class UsersApp {
  constructor(options) {
    this.region = options.region;
    console.log(this.region)
  }

  showUsers() {
    console.log('show users from app')
  }

  showRegistration() {
    console.log('show registration from app');
  }

  startController(Controller) {
    if (this.currentController &&
        this.currentController instanceof Controller) {
      return this.currentController;
    }

    if (this.currentController &&
        this.currentController.destroy) {
      return this.currentController.destroy();
    }

    this.currentController = new Controller({
      region: this.region
    });

    return this.currentController;
  }
}

module.exports = UsersApp;






















