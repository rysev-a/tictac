class User extends Backbone.Model
  defaults:
    id: null
    active: false
    login: ''
    email: ''
    password: ''
    about: ''
    online: false
  url: 'api/users'
  login:->
    data = 
      email: @.get('email')
      password: @.get('password')
    data = JSON.stringify(data)
    $.ajax
      url: 'api/users/login'
      method: 'post'
      dataType: 'json'
      contentType: 'application/json'
      data: data
    

module.exports = User
