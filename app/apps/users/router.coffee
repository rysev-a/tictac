class UsersRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'users': 'showUsers',
      'users/registration': 'showRegistration',
      'users/login': 'showLogin'
    this._bindRoutes();

  showUsers: ()->
    app = @startApp()
    app.showUsers()

  showRegistration: ()->
    app = @startApp()
    app.showRegistration()

  showLogin: ()->
    app = @startApp()
    app.showLogin()

  startApp: ()->
    App = require('../../app')
    UsersApp = require('./app')
    App.startSubApplication(UsersApp)

module.exports = new UsersRouter()
