App = require('../../../../app')
User = require('../models/user')
Message = require('../../../components/message/index')
LoginView = require('../views/loginView')

class LoginPage
  constructor: (options)->
    @user = new User
      email: ''
      password: ''
      login: ''
      about: ''
    
    @region = options.region
    _.extend(this, Backbone.Events)
    App.on('login:start', @startLogin.bind(this))

  showLoginView: ()->
    element = React.createElement(LoginView, user: @user)
    ReactDOM.render(element, document.getElementById(@region))

  startLogin: (user)->
    App.trigger('loading:start')
    user.login().then(
      (response)->
        message = new Message
          content: 'login complete'
        message.showMessageView()
        App.router.navigate('', true)
        App.trigger('profile:login', new User(response))
        App.trigger('loading:stop')
      (response)=>
        message = new Message
          content: response.responseJSON.message
          type: 'error'
        message.showMessageView()
        App.trigger('loading:stop')
    )


module.exports = LoginPage
