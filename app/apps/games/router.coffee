class GamesRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'games': 'showGames',
      'games/:id': 'showGame'
    @_bindRoutes()
    App = require('../../app')
    @.on('route', (route)-> 
      App.trigger('router:change', route))

  showGames: ()->
    app = @startApp()
    app.showGames()

  showGame: (id)->
    app = @startApp()
    app.showGame(id)

  startApp: ()->
    App = require('../../app')
    GamesApp = require('./app')
    App.startSubApplication(GamesApp)

module.exports = new GamesRouter()
