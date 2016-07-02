class GamesRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'games': 'showGames',
      'games/start/:id': 'startGame'
    this._bindRoutes();

  showGames: ()->
    app = @startApp()
    app.showGames()

  startGame: (id)->
    app = @startApp()
    app.startGame(id)

  startApp: ()->
    App = require('../../app')
    GamesApp = require('./app')
    App.startSubApplication(GamesApp)

module.exports = new GamesRouter()
