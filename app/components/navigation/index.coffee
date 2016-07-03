App = require('../../app')
NavigationView = require './views/navigationView'

class Navigation
  showNavigationView: ()->
    element = React.createElement(NavigationView)
    ReactDOM.render(element, document.getElementById('nav'))

module.exports = Navigation
