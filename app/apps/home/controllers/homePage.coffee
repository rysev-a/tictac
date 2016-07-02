HomeView = require('../views/homeView')

class HomePage
  constructor: (options)->
    @region = options.region
    _.extend(this, Backbone.Events)

  showHomeView: ()->
    element = React.createElement(HomeView)
    ReactDOM.render(element, document.getElementById(@region))

module.exports = HomePage
