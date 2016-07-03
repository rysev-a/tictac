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

    if @game.get('creator_id') != App.profile.model.get('id')
      if @game.get('status') == 0
        @initEnemy()

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
        @checkVictory(tempStep)
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

    App.socket.on 'game:initEnemy', (gameData)=>
      @game.set('enemy', gameData.enemy)
      App.trigger 'game:updateGame', @game

    App.on('game:victory', @gameVictory.bind(this))

  initEnemy:->
    App.trigger('loading:start')
    enemy_id = App.profile.model.get('id')
    @game.set('enemy_id', enemy_id)
    @game.set('status', 1)
    @game.save().then(
      (response)=>
        App.trigger('loading:stop')

      (response)=>
        App.trigger('loading:stop'))


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

    if not @checkStepQuere(side)
      return false

    if side == 'creator'
      App.trigger('game:setQueue', 'enemy')
    if side == 'enemy'
      App.trigger('game:setQueue', 'creator')

    new Step({x, y, master_id, side, game_id})

  checkStepQuere: (side)->
    if side != @game.get('queue')
      queueUserName = @game.get(@game.get('queue')).login
      new Message
        type: 'error'
        content: "now quere #{queueUserName}"
      return false
    return true

  saveStep: (step)->
    step.save().then(
      (response)=>
    )

  invertSide: (side)->
    {enemy: 'creator', creator: 'enemy'}[side]

  checkVictory: (step)->
    {x, y, side} = step.toJSON()

    diagonalLeft = []
    diagonalRight = []
    vertical = []
    horizontal = []
    [-5..5].map (item)=>
      diagonalLeft.push(@stepCollection.findWhere({x: x + item, y: y + item, side}))
      diagonalRight.push(@stepCollection.findWhere({x: x - item, y: y + item, side}))
      vertical.push(@stepCollection.findWhere({x, y:y + item, side}))
      horizontal.push(@stepCollection.findWhere({x: x + item, y, side}))

    [diagonalLeft, diagonalRight, horizontal, vertical].map @checkDirection

  checkDirection: (direction)->
    score = 0
    direction.map (step)->
      if step
        ++score
        if score is 5
          App.trigger('game:victory')
      else
        score = 0

  gameVictory:->
    if @game.get('side') == 'creator'
      @game.set('status', 2)
    else
      @game.set('status', 3)
    @game.save().then(
        (response)=>
          new Message(type: 'success', content: 'You win!!!')
          App.router.navigate('games', true)
        (response)=>
          console.log response
      )

  destroy:->
    App.socket.removeAllListeners('game:saveStep')
    App.socket.removeAllListeners('game:initEnemy')
    @stepCollection.reset()
      


module.exports = GamePage
