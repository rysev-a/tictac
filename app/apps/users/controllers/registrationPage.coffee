App = require('../../../../app')
User = require('../models/user')
Message = require('../../../components/message/index')
RegistrationView = require('../views/registrationView')

class RegistrationPage
  constructor: (options)->
    @user = new User
      email: ''
      password: ''
      login: ''
      about: ''
    
    @region = options.region
    _.extend(this, Backbone.Events)
    App.on('registration:start', @startRegistration.bind(this))

  showRegistrationView: ()->
    element = React.createElement(RegistrationView, user: @user)
    ReactDOM.render(element, document.getElementById(@region))

  startRegistration: (user)->
    App.trigger('loading:start')
    user.save().then(
      (response)->
        message = new Message
          content: 'registration complete'
        message.showMessageView()
        App.router.navigate('', true)
        App.trigger('profile:login', user)
        App.trigger('loading:stop')
      (response)=>
        App.trigger('registration:setErrors', response.responseJSON)
        message = new Message
          content: 'oooops!'
          type: 'error'
        App.trigger('loading:stop')
    )


module.exports = RegistrationPage
