App = require '../../../../app'

{table, tbody, thead, td, th, tr} = React.DOM 
{h1, h4, a, p, div, span} = React.DOM

Step = require('../models/step')
StepCollection = require('../collections/stepCollection')

offset =
  position:
    x: 0
    y: 0
  go:(way)->
    {x, y} = offset.position
    switch way
      when 'left'   then offset.position = {x: x-1, y: y}
      when 'right'  then offset.position = {x: x+1, y: y}
      when 'top'    then offset.position = {x: x, y: y+1}
      when 'bottom' then offset.position = {x: x, y: y-1}
    App.trigger('game:setOffset', offset.position)

StepItem = React.createClass
  render:->
    {step} = @props
    top = (step.get('y') + offset.position.y) * 40
    left = (step.get('x') - offset.position.x) * 40
    span
      className: "step #{step.get('side')}"
      style:
        top: "#{top}px"
        left: "#{left}px"
      
StepView = React.createClass
  setView:(collection)->
    @setState('steps': collection)
  getInitialState:->
    {game} = @props
    App.on('game:showStep', (collection)=> 
      @setView(collection))
    App.on('game:setOffset', (position)=> @setState(position: position))
    {steps: game.get('steps'), position: {}}
  render:->
    div
      className: 'steps'
      @state.steps.map (step)=>
        React.createElement(StepItem, 
          key: step.cid, step: step, position: @state.position)

BoardItem = React.createClass
  render:->
    {x, y} = @props
    x = x + offset.position.x
    y = y - offset.position.y
    span
      className: 'board-item'
      onClick: ()-> App.trigger('game:createStep', {x, y})

BoardView = React.createClass
  getInitialState:->
    board = []
    [0..9].map (y)=>
      [0..9].map (x)=>
        key = "#{x}#{y}"
        board.push {x,y,key}
    App.on('game:setOffset', (position)=> @setState(position: position))        
    {board: board, position: {}}
  render:->
    div
      className: 'board'
      @state.board.map (boardItem)=>
        React.createElement(BoardItem, boardItem)

QueueView = React.createClass
  setQueue:(queue)->
    {game} = @props
    @setState(queue: game.get(queue).login)
  getInitialState:->
    App.on('game:setQueue', @setQueue)
    {game} = @props
    {queue: game.get(game.get('queue')).login}
  render:->
    {game} = @props
    div
      className: 'queue'
      "now queue: #{@state.queue}"

ControlView = React.createClass
  render:->
    div
      className: 'control'
      div
        className: 'go-left'
        onClick: ()->  offset.go('left')
      div
        className: 'go-right'
        onClick: ()->  offset.go('right')
      div
        className: 'go-bottom'
        onClick: ()->  offset.go('bottom')
      div
        className: 'go-top'
        onClick: ()->  offset.go('top')

GameView = React.createClass
  getInitialState:->
    App.on 'game:updateGame', (game)=>
      @setState('game': game)
    {game} = @props
    {game: game}
  render:->
    game = @state.game
    creator = game.get('creator').login
    enemy = game.get('enemy').login or 'waiting'

    div
      className: 'game-page'
      div
        className: 'game-users'
        "#{creator} vs #{enemy}"
      React.createElement(QueueView, game: game)
      div
        className: 'game row'
        div {className: 'twelwe columns'},
          React.createElement(ControlView)
          React.createElement(BoardView)
          React.createElement(StepView, game: game)
      
module.exports = GameView
