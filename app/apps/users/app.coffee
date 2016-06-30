UsersPage = require('./usersPage')
RegistrationPage = require('./registrationPage')

class UsersApp
  constructor: (options)->
    @region = options.region

  showUsers: ()->
    usersPage = @startController(UsersPage)
    usersPage.showUsersView()

  showRegistration: ()->
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

module.exports = UsersApp






















