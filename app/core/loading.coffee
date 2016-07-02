User = require '../apps/users/models/user'
App = require '../app'
Message = require '../components/message/index'

Loading =
  init:->
    console.log 'Loading init'
  start:->
    console.log 'start'
  stop:->
    console.log 'stop'

module.exports = Loading
