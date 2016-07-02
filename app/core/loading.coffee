User = require '../apps/users/models/user'
App = require '../app'
Message = require '../components/message/index'

{div} = React.DOM

LoadingView = React.createClass
  getInitialState:->
    Loading.on('start', ()=> @setState(className: 'loading-wrapper inprogress'))
    Loading.on('stop',  ()=> @setState(className: 'loading-wrapper'))
    return className: 'loading-wrapper'
  render:->
    div
      className: @state.className
      div
        className: 'loading'

Loading =
  init:->
    element = React.createElement(LoadingView)
    ReactDOM.render(element, document.getElementById('loading'))
  start:->
    Loading.trigger('start')
  stop:->
    Loading.trigger('stop')

_.extend(Loading, Backbone.Events)

module.exports = Loading
