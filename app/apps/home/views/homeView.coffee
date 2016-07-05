App = require '../../../../app'

{h1, a, p, div} = React.DOM


HomeView = React.createClass
  render:->
    div
      className: 'home'
      h1
        className: 'home-title'
        'tic-tac-toe'
      p
        className: 'home-info'
        'hello!'
      p
        className: 'home-info'
        'register without email activation!'
      p
        className: 'home-info'
        'create game and play in tic tac toe!'

module.exports = HomeView
