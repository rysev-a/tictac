App = require '../../../../app'

{h1, a, p, div, span} = React.DOM

ProfileView = React.createClass

  render:->
    user = App.profile.model
    div
      className: 'profile-page'
      div
        className: 'profile-info'
        div 
          className: 'profile-field'
          span(className: 'profile-label', 'login: ')
          span(className: 'profile-value', user.get('login'))
        div 
          className: 'profile-field'
          span(className: 'profile-label', 'email: ')
          span(className: 'profile-value', user.get('email'))
        div 
          className: 'profile-field'
          span(className: 'profile-label', 'about: ')
          span(className: 'profile-value', user.get('about'))
      div
        className: 'profile-actions'
        a
          className: 'button button-primary'
          onClick: ()-> App.trigger('profile:logout')
          'logout'

module.exports = ProfileView
