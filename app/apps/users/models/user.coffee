class User extends Backbone.Model
  defaults:
    active: false
    login: 'alex'
    email: 'rysev-a@yandex.ru'
    password: 'password'
    about: 'aboutme'
  url: 'api/users'

module.exports = User
