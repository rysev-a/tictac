App = require '../../../../app'

{table, tbody, thead, td, th, tr, h1, a, p, div} = React.DOM

ActionsView = React.createClass
  getInitialState:->
    {game} = @props
    showPlayButton = false
    if game.get('status') is 0
      showPlayButton = true
    if game.get('status') is 1
      if game.get('enemy_id') == App.profile.model.get('id')
        showPlayButton = true
      if game.get('creator_id') == App.profile.model.get('id')
        showPlayButton = true

    {showPlayButton: showPlayButton}
  render:->
    {game} = @props
    if @state.showPlayButton
      a
        className: 'button button-primary start-game'
        onClick: ()-> App.trigger('game:showGame', game.get('id'))
        'play'
    else
      div
        className: null
        '---'

GameItem = React.createClass
  getStatus: (status_id)->
    {game} = @props
    status_map =
      0: 'new'
      1: 'progress'
      2: "#{game.get('creator').login} win"
      3: "#{game.get('enemy').login} win"
      4: 'reject'
    status_map[status_id]

  render:->
    {game} = @props
    creator = game.get('creator').login
    enemy = game.get('enemy').login or 'waiting'
    status = game.get('status')
    tr
      className: null
      td(className: null, game.get('id'))
      td(className: null, creator)
      td(className: null, 'X')
      td(className: null, enemy)
      td(className: null, @getStatus(status))
      td
        className: null
        React.createElement(ActionsView, game: game)

GamesView = React.createClass
  getInitialState:->
    App.on 'game:updateGameList', (gamesData)=>
      @setState(gamesData: gamesData)
    {gamesData} = @props
    {gamesData: gamesData}
  createGame:->
    App.trigger('game:createGame')
  render:->
    gamesData = @state.gamesData
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
              th(className: null, '#')
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
