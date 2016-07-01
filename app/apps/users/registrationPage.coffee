App = require('../../../app')
User = require('./models/user')
Message = require('../../components/message/index')

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
    App.on('start:registration', @startRegistration.bind(this))

  showRegistrationView: ()->
    element = React.createElement(RegistrationView, user: @user)
    ReactDOM.render(element, document.getElementById(@region))

  startRegistration: (user)->

    user.unset('errors')
    @showRegistrationView()
    user.save().then(
      (response)->
        console.log response
        #App.router.navigate('', true)
        message = new Message
          content: 'registration complete'
        message.showMessageView()
      (response)=>
        App.trigger('registration:setErrors', response.responseJSON)
        message = new Message
          content: 'oooops!'
          type: 'error'
        message.showMessageView()
        @showRegistrationView()
    )




module.exports = RegistrationPage
