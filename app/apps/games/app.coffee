App = require('../../../app')
GamesPage = require('./controllers/gamesPage')
# RegistrationPage = require('./registrationPage')
# LoginPage = require('./loginPage')

class GamesApp
  constructor: (options)->
    @region = options.region

  showGames: ()->
    usersPage = @startController(GamesPage)
    usersPage.showGamesView()

  createGame: ()->
    registrationPage = @startController(RegistrationPage)
    registrationPage.showRegistrationView()

  startController: (Controller)->
    if @currentController && @currentController instanceof Controller
      @currentController

    if @currentController && @currentController.destroy
      @currentController.destroy

    @currentController = new Controller
      region: this.region

    return @currentController

  destroy: ()->
    # App.off('registration:start')
    # App.off('registration:setErrors')
    # App.off('login:start')
    
module.exports = GamesApp






















