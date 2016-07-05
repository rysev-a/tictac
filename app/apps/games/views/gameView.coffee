App = require '../../../../app'

{table, tbody, thead, td, th, tr} = React.DOM 
{h1, h4, a, p, div, span} = React.DOM

Step = require('../models/step')
StepCollection = require('../collections/stepCollection')

gamePosition = {x: 0, y: 0}
App.on 'game:navigate', (position)->
  gamePosition = position
  App.trigger 'game:showNavigate', position
  
StepItem = React.createClass
  render:->
    {step} = @props
    top =  (step.get('y') + gamePosition.y) * 40
    left = (step.get('x') - gamePosition.x) * 40
    span
      className: "step #{step.get('side')}"
      style:
        top: "#{top}px"
        left: "#{left}px"
      
StepView = React.createClass
  setView:(collection)->
    App.on 'game:showNavigate', (position)=> @setState(position: position) 
    @setState('steps': collection)
  getInitialState:->
    {game} = @props
    {steps: game.get('steps'), position: {}}
  render:->
    div
      className: 'steps'
      @state.steps.map (step)=>
        React.createElement(StepItem, key: step.cid, step: step)

BoardItem = React.createClass
  render:->
    {x, y} = @props
    [stepX, stepY] = [x + gamePosition.x, y + gamePosition.y]
    span
      className: 'board-item'
      onClick: ()->
        App.trigger('game:sendStep', {x: stepX, y: stepY})
      style:
        top: "#{y * 40}px"
        left: "#{x * 40}px"

BoardView = React.createClass
  getInitialState:->
    {game} = @props
    board = []
    [0..9].map (x)=>
      [0..9].map (y)=>
        key = "#{x}#{y}"
        board.push {x,y,key}
    App.on 'game:showNavigate', (position)=> @setState(position: position)      
    {board: board, position: {}, game: game}
  getClassName:->
    game = @state.game
    statusMap =
      0: 'new'
      1: 'progress'
      2: 'win'
      3: 'win'
      4: 'reject'
    gameState = statusMap[game.get('status')]
    return "board #{gameState}"

  render:->
    div
      className: @getClassName()
      @state.board.map (boardItem)=>
        React.createElement(BoardItem, boardItem)

ControlView = React.createClass
  navigate: (direction)->
    {x, y} = gamePosition
    switch direction
      when 'left'   then gamePosition = {x: x-1, y: y}
      when 'right'  then gamePosition = {x: x+1, y: y}
      when 'top'    then gamePosition = {x: x, y: y+1}
      when 'bottom' then gamePosition = {x: x, y: y-1}
    App.trigger('game:navigate', gamePosition)
  render:->
    div
      className: 'control'
      ['left', 'right', 'bottom', 'top'].map (item)=>
        div
          className: "control-#{item}"
          key: item
          onClick: @navigate.papp(item)

VictoryView = React.createClass
  getInitialState:->
    {game} = @props
    if game.get('status') is 2
      winner = "#{game.get('creator').login}"
    if game.get('status') is 3
      winner = "#{game.get('enemy').login}"
    {game, winner}
  render:->
    h4
      className: 'game-victory'
      "#{@state.winner} win!"

GameView = React.createClass
  getInitialState:->
    App.on 'game:navigate', (position)=> @setState(position: position)
    App.on 'game:update', (game)=>
      @setState(game:game)
    {game} = @props
    {game: game, position: {}}
  render:->
    game = @state.game
    creator = @state.game.get('creator').login
    enemy = @state.game.get('enemy').login ? 'waiting'

    if game.get('status') in [2, 3]
      return React.createElement(VictoryView, game: game)

    div
      className: 'game-page'
      div(className: 'game-users', "#{creator} vs #{enemy}")
      div
        className: 'game row'
        div {className: 'twelwe columns'},
          React.createElement(ControlView)
          React.createElement(BoardView, game:game)
          React.createElement(StepView, game: game)
      
module.exports = GameView
