class User extends Backbone.Model
  defaults:
    active: false
  url: 'api/users'

module.exports = User
