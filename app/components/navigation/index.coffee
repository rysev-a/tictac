NavigationView = require('./views/navigationView')
LinkCollection = require('./collections/linkCollection')
App = require('../../app')

class Navigation
  constructor: ()->
    @region = 'nav'

    @links = new LinkCollection([
      {
        title: 'home',
        url: '',
        active: true
      }
      {
        title: 'games'
        url: 'games'
        visible: 'true'
      }
      {
        title: 'users', 
        url: '/users'}
      {
        title: 'registration', 
        url: 'users/registration'
      }
      {
        title: 'login',
        url: 'users/login'
      }
      {
        title: 'logout',
        url: 'users/logout',
        visible: false,
        callback: ()-> App.trigger('profile:logout')
      }
    ])

    
    #onchange links set css class
    @links.on('change', ()=> @showNavigationView())
    _.extend(this, Backbone.Events)

    App.on('profile:login', ()=>
      console.log 'set link inactive'
      @links.findWhere({title: 'registration'}).set('visible', false)
      @links.findWhere({title: 'login'}).set('visible', false)
      @links.findWhere({title: 'logout'}).set('visible', true)
    )

    App.on('profile:logout', ()=>
      @links.findWhere({title: 'registration'}).set('visible', true)
      @links.findWhere({title: 'login'}).set('visible', true)
      @links.findWhere({title: 'logout'}).set('visible', false)
    )

  showNavigationView: ()->


    element = React.createElement(NavigationView, {links: @links.visibled()})
    ReactDOM.render(element, document.getElementById(@region))

module.exports = Navigation
