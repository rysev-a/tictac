App = require('../../../app')
Message = require('../../../components/message/index')
GameView = require('../views/gameView')
Game = require('../models/game')
Step = require('../models/step')
StepCollection = require('../collections/stepCollection')

class GamePage
  constructor: (options)->
    {@id, @region} = options

  showGameView: ()->
    @initGame()
      .then(
        (response)=>
          @stepCollection = new StepCollection(@game.get('steps'))
          @stepCollection.each((step)=> 
            step.set('side', @getStepSide(step.get('master_id'))))
          @game.set('steps', @stepCollection)
          element = React.createElement(GameView, game: @game)
          ReactDOM.render(element, document.getElementById(@region))
          App.trigger('loading:stop')
          @initListeners()
        ()=>
          App.trigger('loading:stop'))

  initGame: ()->
    new Promise (resolve, reject)=>
      App.trigger('loading:start')
      @game = new Game({id: @id})
      @game.fetch()
        .then(
          ()=>
            resolve()
          ()=>
            resolve())

  initListeners:->
    App.on('game:ready', @ready.bind(this))

    @stepCollection.on('add', 
      ()=> App.trigger('game:showStep', @stepCollection))

    App.on('game:createStep', (id)=>
      tempStep = @createStep(id)
      if tempStep
        @stepCollection.add(tempStep)
        @saveStep(tempStep))

    App.socket.on 'game:saveStep', (stepData)=>
      {x, y} = stepData
      if @stepCollection.findWhere({x: x, y: y})
        return false

      stepData.side = @getStepSide(stepData.master_id)
      @stepCollection.add(new Step(stepData))

  ready: ->
    if @game.get('creator_id') == App.profile.model.get('id')
      App.trigger('game:creatorReady')
    else
      App.trigger('game:enemyReady')

  createStep: (id)->
    {x, y} = @getPosition(id)

    if @stepCollection.findWhere({x: x, y: y})
      message = new Message(type: 'error', content: 'busy!')
      return false

    master_id = App.profile.model.get('id')
    game_id = @game.get('id')
    side = @getStepSide(master_id)
    new Step({x, y, master_id, side, game_id})

  getStepSide:(master_id)->
    if master_id == @game.get('creator').id
      'creator'
    else
      'enemy'

  saveStep: (step)->
    step.save().then(
      (response)=>
    )

  getPosition: (id)->
    x = id % 5
    y = Math.floor(id / 5)
    return {x, y}

  destroy:->
    App.socket.removeAllListeners('game:saveStep')
    @stepCollection.reset()
      


module.exports = GamePage
