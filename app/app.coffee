App =
  Models: {}
  Collections: {}
  Routers: {}
  start: ()->
    _.extend(App, Backbone.Events)
    App.socket = io.connect('http://' + document.domain + ':' + location.port)
    App.initCore()
    App.initComponents()
    App.initRouters()
    
  initRouters:->
    App.mainRegion = 'app'
    App.router = new (require './apps/home/router')
    require './apps/users/router'
    require './apps/games/router'

    Backbone.history.start()

  initCore:->
    App.loading = require './core/loading'
    App.loading.init()
    App.on('loading:start', App.loading.start)
    App.on('loading:stop', App.loading.stop)
    
    App.profile = require './core/profile'
    App.profile.init()
    App.on('profile:login', App.profile.login)
    App.on('profile:logout', App.profile.logout)


  initComponents: ()->
    nav = new (require './components/navigation/index')
    nav.showNavigationView()

  startSubApplication: (SubApplication)->
    if @currentSubapp && @currentSubapp instanceof SubApplication
      @currentSubapp

    if @currentSubapp && @currentSubapp.destroy
      @currentSubapp.destroy()

    @currentSubapp = new SubApplication
      region: App.mainRegion

    return @currentSubapp


module.exports = App
