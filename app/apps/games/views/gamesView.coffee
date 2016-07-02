App = require '../../../../app'

{h1, a, p, div} = React.DOM

GamesView = React.createClass
  render:->
    div
      className: '.games'
      'games!'


module.exports = GamesView
