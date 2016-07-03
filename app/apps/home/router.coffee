class HomeRouter extends Backbone.Router
  constructor: (options)->
    super(options)
    @routes =
      '': 'showIndex'
    @_bindRoutes()
    App = require('../../app')
    @.on('route', (route)-> 
      App.trigger('router:change', route))

  showIndex: ()->
    app = @startApp()
    app.showIndex()

  startApp: ()->
    App = require('../../app')
    HomeApp = require('./app')
    App.startSubApplication(HomeApp)

module.exports = HomeRouter
