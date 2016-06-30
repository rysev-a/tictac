class HomeRouter extends Backbone.Router
  constructor: (options)->
    super(options)
    @routes =
      '': 'showIndex'

    this._bindRoutes()
  showIndex: ()->
    app = @startApp()
    app.showIndex()

  startApp: ()->
    App = require('../../app')
    HomeApp = require('./app')
    App.startSubApplication(HomeApp)

module.exports = HomeRouter
