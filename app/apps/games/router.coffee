class GamesRouter extends Backbone.Router
  constructor: (options)->
    super(options);
    @routes =
      'games': 'showGames',
      'games/create': 'createGame'
    this._bindRoutes();

  showGames: ()->
    app = @startApp()
    app.showGames()

  createGame: ()->
    app = @startApp()
    app.createGame()


  startApp: ()->
    App = require('../../app')
    GamesApp = require('./app')
    App.startSubApplication(GamesApp)

module.exports = new GamesRouter()
