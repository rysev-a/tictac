class UsersRouter extends Backbone.Router
  constructor: (options)->
    super(options)
    @routes =
      'users/registration': 'showRegistration'
      'users/login': 'showLogin'
      'users/profile': 'showProfile'
    @_bindRoutes()
    App = require('../../app')
    @.on('route', (route)-> 
      App.trigger('router:change', route))

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
