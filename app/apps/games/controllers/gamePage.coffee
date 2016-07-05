App = require('../../../app')
Message = require('../../../components/message/index')
GameView = require('../views/gameView')
Game = require('../models/game')
Step = require('../models/step')
StepCollection = require('../collections/stepCollection')

class GameStep
  constructor: ({@x, @y}, @game)->
    @stepCollection = @game.get('steps')

  send:->
    @step = new Step
      x: @x
      y: @y
      side: @game.get('side')
      master_id: App.profile.model.get('id')
      game_id: @game.get('id')

    if @stepCollection.findWhere({@x, @y})
      new Message(type: 'error', content: 'busy!')
      return false

    if @game.get('side') isnt @game.get('queue') 
      new Message(type: 'error', content: 'wait opponent')
      return false

    @save()
  
  save:->
    @step.save()
      .done null
      .error null

class NewGame
  constructor: ({@id, @region})->
      room = "room_#{@id}"
      App.socket.emit('join', {room: room})

  showGameView:->
    @initGame().then(
      ()=>
        element = React.createElement(GameView, game: @game)
        ReactDOM.render(element, document.getElementById(@region))
      )

  initGame:->
    new Promise (resolve, reject)=>
      @game = new Game({id: @id})
      @game.fetch()
        .then(
          ()=>
            @initGameSteps()
            @initGameQueue()
            @initGameSide()
            @initGameEnemy()
            @initGameEvents()
            @initSockets()
            resolve()
          ()=>
            resolve())

  initGameSteps:->
    steps = new StepCollection(@game.get('steps'))
    steps.each((step)=> 
      step.set('side', 'enemy')
      if step.get('master_id') == @game.get('creator_id')
        step.set('side', 'creator'))

    @game.set('steps', steps)
  
  initGameQueue: ()->
    @game.set('queue', 'enemy')
    if (not @game.get('steps').last() or
        @game.get('steps').last().get('side') is 'enemy')
      @game.set('queue', 'creator')

  initGameSide: ()->
    @game.set('side', 'enemy')
    if @game.get('creator_id') == App.profile.model.get('id')
      @game.set('side', 'creator')

  initGameEnemy: ()->
    if @game.get('creator_id') isnt App.profile.model.get('id')
      if @game.get('status') is 0
        @game.set
          enemy: App.profile.model.toJSON()
          enemy_id: App.profile.model.get('id')
          status: 1
        @game.save()

  initGameEvents: ()->
    @game.on('change': ()=> App.trigger('game:update', @game))
    App.on('game:sendStep', @sendStep.bind(this))

  sendStep: ({x, y})->
    step = new GameStep({x, y}, @game)
    step.send()

  setStepSide: (step)->
    if step.get('master_id') is @game.get('creator_id') 
      step.set('side', 'creator')

  initSockets: ->
    App.socket.on 'game:saveStep', @addStep.bind(this)
    App.socket.on 'game:update', (data)=>
      @game.set(data)
      App.trigger('game:update', @game)

  ### activated by socket for both users ###
  addStep: (data)->
    step = new Step(data)
    @showQueue(step)
    @setStepSide(step)
    @game.get('steps').add(step)
    @initGameQueue()
    @game.trigger('change')
    @checkVictory(step)

  showQueue: (step)->
    if App.profile.model.get('id') isnt step.get('master_id')
      new Message
        type: 'success'
        content: 'you queue'

  checkVictory: (step)->
    #check victory only on step master page
    if step.get('master_id') isnt App.profile.model.get('id')
      return false

    steps = @game.get('steps')
    {x, y, side} = step.toJSON()

    [left, right, horizontal, vertical] = [[],[],[],[]]
    [-5..5].map (offset)=>
      left.push(steps.findWhere({x: x + offset, y: y + offset, side}))
      right.push(steps.findWhere({x: x - offset, y: y + offset, side}))
      horizontal.push(steps.findWhere({x, y:y + offset, side}))
      vertical.push(steps.findWhere({x: x + offset, y, side}))

    [left, right, horizontal, vertical].map @checkScore.bind(this)

  checkScore: (direction)->
    score = 0
    direction.map (step)=>
      if step
        ++score
        if score is 5
          @showVictory()
      else
        score = 0
  
  showVictory:->
    status = if @game.get('side') is 'creator' then 2 else 3
    @game.set('status', status)
    @game.save()

  ####### ..... #######

  destroy:->
    App.socket.removeAllListeners('game:saveStep')
    App.socket.removeAllListeners('game:update')
    @game.off()

module.exports = NewGame
