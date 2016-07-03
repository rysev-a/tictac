User = require '../apps/users/models/user'
App = require '../app'
Message = require '../components/message/index'
Profile =
  init:->
    new Promise (resolve, reject)->
      request = $.ajax
        url: 'api/users/current'
      request.then(
        (response)=>
          model = new User(response)
          App.trigger('profile:login', model)
          resolve()
        (response)=>
          console.log 'user unauthorized'
          resolve()
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
        Profile.model.set('online', false)
        App.router.navigate('', true)
      (response)=>
        console.log(response)
    )

module.exports = Profile
