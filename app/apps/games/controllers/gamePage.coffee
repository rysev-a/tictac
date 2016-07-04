App = require('../../../app')
Message = require('../../../components/message/index')
GameView = require('../views/gameView')
Game = require('../models/game')
Step = require('../models/step')
StepCollection = require('../collections/stepCollection')


# class GamePage
#   constructor: (options)->
#     {@id, @region} = options

#   showGameView: ()->
#     @initGame()
#       .then(
#         (response)=>
#           element = React.createElement(GameView, game: @game)
#           ReactDOM.render(element, document.getElementById(@region))
#           @initListeners()
#         ()=>
#           console.log('error'))

#   initGame: ()->
#     new Promise (resolve, reject)=>
#       @game = new Game({id: @id})
#       @game.fetch()
#         .then(
#           ()=>
#             @initGameData()
#             resolve()
#           ()=>
#             resolve())

#   initGameData: ()->
#     @stepCollection = new StepCollection(@game.get('steps'))
#     @stepCollection.each((step)=> 
#       step.set('side', 
#         if step.get('master_id') == @game.get('creator_id')
#           'creator'
#         else
#           'enemy'
#       ))

#     @game.set('steps', @stepCollection)
#     @initGameQueue()
#     @initGameSide()

#   initGameSide: ()->
#     @game.set('side', 'enemy')
#     if @game.get('creator_id') == App.profile.model.get('id')
#       @game.set('side', 'creator')

#     if @game.get('creator_id') != App.profile.model.get('id')
#       if @game.get('status') == 0
#         @initEnemy()

#   initGameQueue: ()->
#     @game.set('queue', 'enemy')
#     if not @stepCollection.last()
#       @game.set('queue', 'creator')
#       return true
#     if @stepCollection.last().get('side') is 'enemy'
#       @game.set('queue', 'creator')

#   initListeners:->
#     @stepCollection.on('add', 
#       ()=> App.trigger('game:showStep', @stepCollection))

#     App.on('game:createStep', ({x, y})=>
#       tempStep = @createStep({x, y})
#       if tempStep
#         @stepCollection.add(tempStep)
#         @checkVictory(tempStep)
#         @saveStep(tempStep))

#     App.on('game:setQueue', (queue)=>
#       @game.set('queue', queue))

#     App.socket.on 'game:saveStep', (stepData)=>
#       {x, y} = stepData
#       if @stepCollection.findWhere({x: x, y: y})
#         return false

#       stepData.side = @getStepSide(stepData.master_id)
#       App.trigger('game:setQueue', @invertSide(stepData.side))
#       new Message(type: 'success', content: 'your queue')
#       @stepCollection.add(new Step(stepData))

#     App.socket.on 'game:initEnemy', (gameData)=>
#       @game.set('enemy', gameData.enemy)
#       App.trigger 'game:updateGame', @game

#     App.on('game:victory', @gameVictory.bind(this))

#   initEnemy:->
#     App.trigger('loading:start')
#     enemy_id = App.profile.model.get('id')
#     @game.set('enemy_id', enemy_id)
#     @game.set('status', 1)
#     @game.save().then(
#       (response)=>
#         App.trigger('loading:stop')

#       (response)=>
#         App.trigger('loading:stop'))

#   getStepSide: (master_id)->
#     if master_id == @game.get('creator_id')
#       return 'creator'
#     else
#       return 'enemy'

#   createStep: ({x, y})->
#     if @stepCollection.findWhere({x: x, y: y})
#       new Message(type: 'error', content: 'busy!')
#       return false

#     master_id = App.profile.model.get('id')
#     game_id = @game.get('id')

#     side = @game.get('side')

#     if not @checkStepQuere(side)
#       return false

#     if side == 'creator'
#       App.trigger('game:setQueue', 'enemy')
#     if side == 'enemy'
#       App.trigger('game:setQueue', 'creator')

#     new Step({x, y, master_id, side, game_id})

#   checkStepQuere: (side)->
#     if side != @game.get('queue')
#       queueUserName = @game.get(@game.get('queue')).login
#       new Message
#         type: 'error'
#         content: "now quere #{queueUserName}"
#       return false
#     return true

#   saveStep: (step)->
#     step.save().then(
#       (response)=>
#     )

#   invertSide: (side)->
#     {enemy: 'creator', creator: 'enemy'}[side]

#   checkVictory: (step)->
#     {x, y, side} = step.toJSON()

#     diagonalLeft = []
#     diagonalRight = []
#     vertical = []
#     horizontal = []
#     [-5..5].map (item)=>
#       diagonalLeft.push(@stepCollection.findWhere({x: x + item, y: y + item, side}))
#       diagonalRight.push(@stepCollection.findWhere({x: x - item, y: y + item, side}))
#       vertical.push(@stepCollection.findWhere({x, y:y + item, side}))
#       horizontal.push(@stepCollection.findWhere({x: x + item, y, side}))

#     [diagonalLeft, diagonalRight, horizontal, vertical].map @checkDirection

#   checkDirection: (direction)->
#     score = 0
#     direction.map (step)->
#       if step
#         ++score
#         if score is 5
#           App.trigger('game:victory')
#       else
#         score = 0

#   gameVictory:->
#     if @game.get('side') == 'creator'
#       @game.set('status', 2)
#     else
#       @game.set('status', 3)
#     @game.save().then(
#         (response)=>
#           new Message(type: 'success', content: 'You win!!!')
#           App.router.navigate('games', true)
#         (response)=>
#           console.log response
#       )

#   destroy:->
#     App.socket.removeAllListeners('game:saveStep')
#     App.socket.removeAllListeners('game:initEnemy')
#     @stepCollection.reset()
      
#module.exports = GamePage

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

    # if not @game.get('side') is @game.get('queue') 
    #   new Message(type: 'error', content: 'wait opponent')
    #   return false

    @save()
  
  save:->
    @step.save()
      .done null
      .error null


class NewGame
  constructor: ({@id, @region})->
  
  showGameView:->
    @initGame().then(
      ()=>
        element = React.createElement(GameView, game: @game)
        ReactDOM.render(element, document.getElementById(@region))
      )
    #App.router.navigate('games')

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

  initSockets: ->
    App.socket.on 'game:saveStep', @addStep.bind(this)
    App.socket.on 'game:update', (data)=>
      @game.set(data)
      App.trigger('game:update', @game)

  sendStep: ({x, y})->
    step = new GameStep({x, y}, @game)
    step.send()

  setStepSide: (step)->
    if step.get('master_id') is @game.get('creator_id') 
      step.set('side', 'creator')

  addStep: (data)->
    step = new Step(data)
    @setStepSide(step)
    @game.get('steps').add(step)
    @checkVictory(step)
    @game.trigger('change')

  checkVictory: (step)->
    steps = @game.get('steps')
    {x, y, side} = step.toJSON()

    [left, right, horizontal, vertical] = [[],[],[],[]]
    [-5..5].map (offset)=>
      left.push(steps.findWhere({x: x + offset, y: y + offset, side}))
      right.push(steps.findWhere({x: x - offset, y: y + offset, side}))
      horizontal.push(steps.findWhere({x, y:y + offset, side}))
      vertical.push(steps.findWhere({x: x + offset, y, side}))

    [left, right, horizontal, vertical].map @checkScore

  checkScore: (direction)->
    score = 0
    direction.map (step)->
      if step
        ++score
        if score is 5
          App.trigger('game:victory')
      else
        score = 0

module.exports = NewGame
