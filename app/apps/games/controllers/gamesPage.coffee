App = require('../../../app')
GamesView = require('../views/gamesView')
Game = require('../models/game')
GameCollection = require '../collections/gameCollection'

class GamesPage
  constructor: (options)->
    App.on('game:createGame', @createGame.bind(this))
    App.on('game:showGame', @showGame.bind(this))

    @region = options.region
    @initGames()

  initGames: ()->
    @gameCollection = new GameCollection
    @gameCollection.fetch()
    
  showGamesView: ()->
    App.trigger('loading:start')
    @initGames().then(
      ()=>
        element = React.createElement(GamesView, gamesData: @gameCollection)
        ReactDOM.render(element, document.getElementById(@region))
        App.trigger('loading:stop')
      ()=>
        App.trigger('loading:stop')
    )

  createGame: ()->
    game = new Game
     creator_id: App.profile.model.get('id')
    game.save().then(
      (response)=>
        console.log response
      (response)=>
        console.log response
    )

  showGame: (id)->
    App.router.navigate("games/#{id}", true)

module.exports = GamesPage
