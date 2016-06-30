

App =
  Models: {}
  Collections: {}
  Routers: {}
  start: ()->
    HomeRouter = require './apps/home/router'
    require './apps/users/router'
    App.mainRegion = 'app'
    App.router = new HomeRouter
    Backbone.history.start()
    App.startComponents();

  startSubApplication: (SubApplication)->
    if @currentSubapp && @currentSubapp instanceof SubApplication
      @currentSubapp

    if @currentSubapp && @currentSubapp.destroy
      @currentSubapp.destroy

    @currentSubapp = new SubApplication
      region: App.mainRegion

    return @currentSubapp;

  startComponents: ()->
    nav = new (require './components/navigation/index')
    nav.showNavigationView()

_.extend(App, Backbone.Events);


module.exports = App
