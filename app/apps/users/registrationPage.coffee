App = require('../../../app')
User = require('./models/user')

RegistrationView = require('./views/registrationView')

class RegistrationPage
  constructor: (options)->
    @user = new User(
      email: 'myemail@gmail.com'
      password: '12345'
      login: 'player'
      about: 'about me'
    )
    
    @region = options.region
    _.extend(this, Backbone.Events)
    App.on('start:registration', @startRegistration)

  showRegistrationView: ()->
    element = React.createElement(RegistrationView, user: @user)
    ReactDOM.render(element, document.getElementById(@region))

  startRegistration: (user)->
    user.save()
    console.log(user.get('email'))


module.exports = RegistrationPage
