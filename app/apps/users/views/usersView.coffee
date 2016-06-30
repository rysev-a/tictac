App = require '../../../../app'

{h1, a, p, div} = React.DOM

UsersView = React.createClass
  goToHome:->
    App.router.navigate '', true

  render:->
    div
      className: 'elements'
      a
        className: 'button button-primary'
        onClick: @goToHome
        'home'
      div
        className: '.home'
        'users'


module.exports = UsersView
