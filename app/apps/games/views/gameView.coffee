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
    console.log @state.steps
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

ReadyView = React.createClass
  getInitialState:->
    App.on('game:creatorReady', 
      ()=> @setState(creatorReady: true))
    App.on('game:enemyReady',
      ()=> @setState(enemyReady: true))
    {creatorReady: false, enemyReady: false}
  render:->
    div
      className: 'ready'
      div
        className: 'ready-info'
        span(className: 'ready-field', 'creator: ')
        span
          className: 'ready-value'
          if @state.creatorReady then 'ready!' else 'wait'
      div
        className: 'ready-info'
        span(className: 'ready-field', 'enemy: ')
        span
          className: 'ready-value'
          if @state.enemyReady then 'ready!' else 'wait'
      div {className: 'ready-buttons'},
        a
          className: 'button button-primary'
          onClick: ()-> App.trigger('game:ready')
          'are you ready?'

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
        className: 'game row'
        div {className: 'six columns'},
          React.createElement(BoardView)
          React.createElement(StepView, game: game)
        div {className: 'six columns'},
          React.createElement(ReadyView)
      
module.exports = GameView
