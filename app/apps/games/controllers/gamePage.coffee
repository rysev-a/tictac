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
          element = React.createElement(GameView, game: @game)
          ReactDOM.render(element, document.getElementById(@region))
          @initListeners()
        ()=>
          console.log('error'))

  initGame: ()->
    new Promise (resolve, reject)=>
      @game = new Game({id: @id})
      @game.fetch()
        .then(
          ()=>
            @initGameData()
            resolve()
          ()=>
            resolve())

  initGameData: ()->
    @stepCollection = new StepCollection(@game.get('steps'))
    @stepCollection.each((step)=> 
      step.set('side', 
        if step.get('master_id') == @game.get('creator_id')
          'creator'
        else
          'enemy'
      ))

    @game.set('steps', @stepCollection)
    @initGameQueue()
    @initGameSide()

  initGameSide: ()->
    @game.set('side', 'enemy')
    if @game.get('creator_id') == App.profile.model.get('id')
      @game.set('side', 'creator')

  initGameQueue: ()->
    @game.set('queue', 'enemy')
    if not @stepCollection.last()
      @game.set('queue', 'creator')
      return true
    if @stepCollection.last().get('side') is 'enemy'
      @game.set('queue', 'creator')

  initListeners:->
    @stepCollection.on('add', 
      ()=> App.trigger('game:showStep', @stepCollection))

    App.on('game:createStep', ({x, y})=>
      tempStep = @createStep({x, y})
      if tempStep
        @stepCollection.add(tempStep)
        @saveStep(tempStep))

    App.on('game:setQueue', (queue)=>
      @game.set('queue', queue))

    App.socket.on 'game:saveStep', (stepData)=>
      {x, y} = stepData
      if @stepCollection.findWhere({x: x, y: y})
        return false

      stepData.side = @getStepSide(stepData.master_id)
      App.trigger('game:setQueue', @invertSide(stepData.side))
      new Message(type: 'success', content: 'your queue')
      @stepCollection.add(new Step(stepData))

  getStepSide: (master_id)->
    if master_id == @game.get('creator_id')
      return 'creator'
    else
      return 'enemy'

  createStep: ({x, y})->
    if @stepCollection.findWhere({x: x, y: y})
      new Message(type: 'error', content: 'busy!')
      return false

    master_id = App.profile.model.get('id')
    game_id = @game.get('id')
    side = @game.get('side')

    if side != @game.get('queue')
      new Message
        type: 'error'
        content: "now quere #{@game.get('queue')}"
      return

    if side == 'creator'
      App.trigger('game:setQueue', 'enemy')
    if side == 'enemy'
      App.trigger('game:setQueue', 'creator')

    new Step({x, y, master_id, side, game_id})

  saveStep: (step)->
    step.save().then(
      (response)=>
    )

  invertSide: (side)->
    {enemy: 'creator', creator: 'enemy'}[side]

  getPosition: (id)->
    x = id % 5
    y = Math.floor(id / 5)
    return {x, y}

  destroy:->
    App.socket.removeAllListeners('game:saveStep')
    @stepCollection.reset()
      


module.exports = GamePage
