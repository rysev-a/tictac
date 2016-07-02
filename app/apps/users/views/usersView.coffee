App = require '../../../../app'

{h1, a, p, div} = React.DOM

UsersView = React.createClass
  action:->
    #App.trigger('loading:start')
    #App.router.navigate '', true
    console.log App.profile.model

  render:->
    div
      className: 'elements'
      a
        className: 'button button-primary'
        onClick: @action
        'hack'


module.exports = UsersView
