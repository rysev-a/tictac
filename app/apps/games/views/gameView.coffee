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
    App.on('game:showStep', (collection)=> 
      @setView(collection))
    {steps: []}
  render:->
    div
      className: 'steps'
      @state.steps.map (step)->
        React.createElement(StepItem, key: step.cid, step: step)


BoardItem = React.createClass
  render:->
    {id} = @props
    span
      className: 'board-item'
      onClick: ()-> App.trigger('game:createStep', id)

BoardView = React.createClass
  render:->
    div
      className: 'board'
      [0..24].map (item)=>
        React.createElement(BoardItem, key: item, id: item)

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
      div
        className: 'game'
        React.createElement(BoardView)
        React.createElement(StepView)
      
module.exports = GameView
