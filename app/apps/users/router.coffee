class UsersRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'users': 'showUsers'
      'users/registration': 'showRegistration'
      'users/login': 'showLogin'
      'users/profile': 'showProfile'
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

  showProfile: ()->
    app = @startApp()
    app.showProfile()

  startApp: ()->
    App = require('../../app')
    UsersApp = require('./app')
    App.startSubApplication(UsersApp)

module.exports = new UsersRouter()
