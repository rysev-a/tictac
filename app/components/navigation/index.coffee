NavigationView = require('./views/navigationView')
LinkCollection = require('./collections/linkCollection')

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
        title: 'users', 
        url: '/users'}
      {
        title: 'registration', 
        url: 'users/registration'
      }
    ])

    #onchange links set css class
    @links.on('change', ()=> @showNavigationView())
    _.extend(this, Backbone.Events)

  showNavigationView: ()->
    element = React.createElement(NavigationView, {links: @links})
    ReactDOM.render(element, document.getElementById(@region))

module.exports = Navigation
