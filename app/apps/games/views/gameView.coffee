App = require '../../../../app'

{table, tbody, thead, td, th, tr} = React.DOM 
{h1, h4, a, p, div, span} = React.DOM

Step = require('../models/step')
StepCollection = require('../collections/stepCollection')

StepItem = React.createClass
  render:->
    {step} = @props
    top = step.get('y') * 40
    left = step.get('x') * 40
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
    {steps: game.get('steps'), position: {}}
  render:->
    div
      className: 'steps'
      @state.steps.map (step)=>
        React.createElement(StepItem, key: step.cid, step: step)

BoardItem = React.createClass
  render:->
    {x, y} = @props
    span
      className: 'board-item'
      onClick: ()->
        App.trigger('game:sendStep', {x, y})
      style:
        top: "#{y * 40}px"
        left: "#{x * 40}px"

BoardView = React.createClass
  getInitialState:->
    board = []
    [0..9].map (x)=>
      [0..9].map (y)=>
        key = "#{x}#{y}"
        board.push {x,y,key}
    App.on('game:setOffset', (position)=> @setState(position: position))        
    {board: board, position: {}}
  render:->
    div
      className: 'board'
      @state.board.map (boardItem)=>
        React.createElement(BoardItem, boardItem)

ControlView = React.createClass
  render:->
    div
      className: 'control'
      ['left', 'right', 'bottom', 'top'].map (item)=>
        div(className: "control-#{item}")

GameView = React.createClass
  getInitialState:->
    App.on 'game:update', (game)=>
      @setState(game:game)
    {game} = @props
    {game: game}
  render:->
    game = @state.game
    div
      className: 'game-page'
      div
        className: 'game row'
        div {className: 'twelwe columns'},
          #React.createElement(ControlView)
          React.createElement(BoardView)
          React.createElement(StepView, game: game)
      
module.exports = GameView
