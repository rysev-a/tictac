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
    App.on('game:showStep', (collection)=> 
      @setView(collection))
    {steps: game.get('steps')}
  render:->
    div
      className: 'steps'
      @state.steps.map (step)->
        React.createElement(StepItem, key: step.cid, step: step)

BoardItem = React.createClass
  render:->
    {x, y} = @props
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
    {board: board}
  render:->
    div
      className: 'board'
      @state.board.map (boardItem)=>
        React.createElement(BoardItem, boardItem)

QueueView = React.createClass
  setQueue:(queue)->
    @setState(queue: queue)
  getInitialState:->
    App.on('game:setQueue', @setQueue)
    {game} = @props
    {queue: game.get('queue')}
  render:->
    div
      className: 'queue'
      "now queue: #{@state.queue}"


GameView = React.createClass
  render:->
    {game} = @props
    creator = game.get('creator').login
    enemy = game.get('enemy').login or 'waiting'
    div
      className: 'game-page'
      h4
        className: 'game-title'
        "#{creator} vs #{enemy}"
      React.createElement(QueueView, game: game)
      div
        className: 'game row'
        div {className: 'twelwe columns'},
          React.createElement(BoardView)
          React.createElement(StepView, game: game)
      
module.exports = GameView
