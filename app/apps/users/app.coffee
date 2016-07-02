App = require('../../../app')
UsersPage = require('./controllers/usersPage')
RegistrationPage = require('./controllers/registrationPage')
LoginPage = require('./controllers/loginPage')

class UsersApp
  constructor: (options)->
    @region = options.region

  showUsers: ()->
    usersPage = @startController(UsersPage)
    usersPage.showUsersView()

  showRegistration: ()->
    registrationPage = @startController(RegistrationPage)
    registrationPage.showRegistrationView()

  showLogin: ()->
    loginPage = @startController(LoginPage)
    loginPage.showLoginView()

  startController: (Controller)->
    if @currentController && @currentController instanceof Controller
      @currentController

    if @currentController && @currentController.destroy
      @currentController.destroy

    @currentController = new Controller
      region: this.region

    return @currentController

  destroy: ()->
    App.off('registration:start')
    App.off('registration:setErrors')
    App.off('login:start')
    
module.exports = UsersApp






















