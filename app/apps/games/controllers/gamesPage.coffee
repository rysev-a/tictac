App = require('../../../app')
GamesView = require('../views/gamesView')
Game = require('../models/game')
GameCollection = require '../collections/gameCollection'

class GamesPage
  constructor: (options)->
    App.on('game:createGame', @createGame.bind(this))
    App.on('game:showGame', @showGame.bind(this))
    App.socket.on 'game:createGame', ()=>
      @initGames().then ()=>
        App.trigger('game:updateGameList', @gameCollection)

    @region = options.region


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

      (response)=>

    )

  showGame: (id)->
    App.router.navigate("games/#{id}", true)

  destroy:->
    App.socket.removeAllListeners('game:createGame')

module.exports = GamesPage
