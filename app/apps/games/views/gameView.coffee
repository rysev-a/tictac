App = require '../../../../app'

{table, tbody, thead, td, th, tr, h1, a, p, div} = React.DOM


GameView = React.createClass
  render:->
    {game} = @props
    div
      className: 'games'
      "game vs #{game.get('creator').login}"
      
module.exports = GameView
