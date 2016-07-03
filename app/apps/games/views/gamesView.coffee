App = require '../../../../app'

{table, tbody, thead, td, th, tr, h1, a, p, div} = React.DOM

GameItem = React.createClass
  render:->
    {game} = @props
    creator = game.get('creator').login
    enemy = game.get('enemy').login or 'waiting'
    status = game.get('status')
    tr
      className: null
      td(className: null, creator)
      td(className: null, 'X')
      td(className: null, enemy)
      td(className: null, status)
      td
        className: null
        if status is 'created'
          a
            className: 'button button-primary start-game'
            onClick: ()-> App.trigger('game:showGame', game.get('id'))
            'play'

GamesView = React.createClass
  createGame:->
    App.trigger('game:createGame')
  render:->
    {gamesData} = @props
    div
      className: 'games'
      div
        className: 'games-list'
        table
          className: "u-full-width"
          thead
            className: null
            tr
              className: null
              th(className: null, 'Creator')
              th(className: null, 'vs')
              th(className: null, 'Enemy')
              th(className: null, 'Status')
              th(className: null, 'Action')
          tbody
            className: null
            gamesData.map (game)->
              React.createElement(GameItem, game:game, key: game.cid)
      div
        className: 'games-actions'
        a
          className: 'button button-primary'
          onClick: @createGame
          'create game'


module.exports = GamesView
