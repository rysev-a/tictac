App = require '../../../../app'

{h1, a, p, div} = React.DOM


HomeView = React.createClass
  render:->
    div
      className: '.home'
      'hello!'


module.exports = HomeView
