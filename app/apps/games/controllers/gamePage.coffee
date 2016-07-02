App = require('../../../app')
GameView = require('../views/gameView')
Game = require('../models/game')
GameCollection = require '../collections/gameCollection'

class GamePage
  constructor: (options)->
    {@id, @region} = options

  initGame: ()->
    App.trigger('loading:start')
    @game = new Game({id: @id})
    @game.fetch()
      .then(()=>
        @game.unset('enemy')
        @game.unset('creator')
        @game.set('status', 1)
        @game.set('enemy_id', App.profile.model.get('id'))
        @game.save())
    
  showGameView: ()->
    @initGame()
      .then(
        (response)=>
          App.trigger('loading:stop')
          element = React.createElement(GameView, game: @game)
          ReactDOM.render(element, document.getElementById(@region))
        ()=>
          App.trigger('loading:stop')
      )  
      


module.exports = GamePage
