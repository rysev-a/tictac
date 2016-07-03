App = require '../../../../app'

console.log App.profile
console.log App.profile.model

{h1, a, p, div} = React.DOM

ProfileView = React.createClass

  render:->
    div
      className: 'profile-page'
      div
        className: 'profile'
        App.profile.model.get('login')

module.exports = ProfileView
