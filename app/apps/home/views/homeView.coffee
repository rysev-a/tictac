App = require '../../../../app'
console.log(App);

{h1, a, p, div} = React.DOM


HomeView = React.createClass
  goToUsers:->
    App.router.navigate 'users', true

  render:->
    div
      className: 'elements'
      a
        className: 'button button-primary'
        onClick: @goToUsers
        'users'
      div
        className: '.home'
        'home'


module.exports = HomeView
