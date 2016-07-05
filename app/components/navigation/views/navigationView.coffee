App = require '../../../../app'
{h1, a, p, div, li} = React.DOM

links = 
    home: url: ''
    games: url: 'games'
    registration: url: 'users/registration'
    login: url: 'users/login'
    profile: url: 'users/profile'

LinkView = React.createClass
  getClassName:(link)->
    {activeUrl} = @props
    if activeUrl == links[link].url then 'navbar-link active' else 'navbar-link'

  render:->
    {link} = @props
    li
      className: 'navbar-item'
      a
        className: @getClassName(link)
        href: "##{links[link].url}"
        link

logged = ['home', 'games','profile']
unlogged = ['home', 'registration', 'login']
NavigationView = React.createClass

  getInitialState: ->
    if App.profile.model
      visibleLinks = logged
    else
      visibleLinks = unlogged

    activeUrl = Backbone.history.fragment
    @initListeners()
    {visibleLinks, activeUrl}

  initListeners:->
    App.on('router:change', ()=> @setState(activeUrl: Backbone.history.fragment))
    App.on('profile:logout', ()=> @setState(visibleLinks: unlogged))
    App.on('profile:login', ()=> @setState(visibleLinks: logged))

  render:->
    div
      className: 'container'
      div
        className: 'navbar-list'
        @state.visibleLinks.map (link)=>
          React.createElement(LinkView, 
            link: link, key: link, activeUrl: @state.activeUrl)


module.exports = NavigationView
