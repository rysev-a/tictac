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
    App.off('game:updateGameList')

    App.off('game:update')
    App.off('game:createStep')
    App.off('game:sendStep')
    App.off('game:navigate')

    
module.exports = GamesApp






















