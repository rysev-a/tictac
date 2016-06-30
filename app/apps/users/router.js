class UsersRouter extends Backbone.Router {
  constructor(options) {
    super(options);
    this.routes = {
      'users': 'showUsers',
      'users/registration': 'showRegistration'
    };
    this._bindRoutes();
  }

  // Redirect to contacts app by default
  showUsers() {
    var app = this.startApp();
    app.showUsers();
    console.log(app);
  }

  showRegistration() {
    var app = this.startApp();
    app.showRegistration();
  }

  startApp() {
    var App = require('../../app');
    var UsersApp = require('./app');
    return App.startSubApplication(UsersApp);
  }

}
module.exports = new UsersRouter();
