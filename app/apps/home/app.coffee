HomePage = require('./homePage')

class HomeApp
  constructor: (options)->
    @region = options.region
  
  showIndex: ()->
    homePage = @startController(HomePage)
    homePage.showHomeView()

  startController: (Controller)->
    if @currentController && @currentController instanceof Controller
      @currentController

    if @currentController && @currentController.destroy
      @currentController.destroy()

    @currentController = new Controller(region: @region)
    return @currentController

module.exports = HomeApp;
