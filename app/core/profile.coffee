User = require '../apps/users/models/user'
App = require '../app'
Message = require '../components/message/index'
Profile =
  init:->
    request = $.ajax
      url: 'api/users/current'
    request.then(
      (response)=>
        model = new User(response)
        App.trigger('profile:login', model)
      (response)=>
        console.log response
    )
  login:(model)->
    Profile.model = model
  logout:->
    request = $.ajax
      url: 'api/users/logout'
      method: 'post'

    request.then(
      (response)=>
        message = new Message
          content: response.message
          type: 'success'
        message.showMessageView()
        Profile.model.set('online', false)
        App.router.navigate('', true)
      (response)=>
        console.log(response)
    )

module.exports = Profile
