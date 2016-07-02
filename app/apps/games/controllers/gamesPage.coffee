GamesView = require('../views/gamesView')

class GamesPage
  constructor: (options)->
    @region = options.region
    _.extend(this, Backbone.Events)

  showGamesView: ()->
    element = React.createElement(GamesView)
    ReactDOM.render(element, document.getElementById(@region))

module.exports = GamesPage
