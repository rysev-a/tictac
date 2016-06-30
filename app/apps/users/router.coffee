class UsersRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'users': 'showUsers',
      'users/registration': 'showRegistration'
    this._bindRoutes();

  showUsers: ()->
    app = @startApp()
    app.showUsers()

  showRegistration: ()->
    app = @startApp()
    app.showRegistration()

  startApp: ()->
    App = require('../../app')
    UsersApp = require('./app')
    App.startSubApplication(UsersApp)

module.exports = new UsersRouter()
