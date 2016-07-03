App = require('../../../app')
GamesPage = require('./controllers/gamesPage')
GamePage = require('./controllers/gamePage')


class GamesApp
  constructor: (options)->
    @region = options.region

  showGames: ()->
    gamesPage = @startController(GamesPage)
    gamesPage.showGamesView()

  showGame: (id)->
    @id = id
    gamePage = @startController(GamePage, id)
    gamePage.showGameView()

  startController: (Controller)->
    if @currentController && @currentController instanceof Controller
      @currentController

    if @currentController && @currentController.destroy
      @currentController.destroy()

    @currentController = new Controller
      region: @region
      id: @id

    return @currentController

  destroy: ()->
    if @currentController.destroy
      @currentController.destroy()
    App.off('game:createGame')
    App.off('game:showGame')
    App.off('game:updateGameList')

    App.off('game:createStep')
    App.off('game:showStep')
    App.off('game:setQueue')
    App.off('game:setOffset')
    App.off('game:updateGame')
    
module.exports = GamesApp






















