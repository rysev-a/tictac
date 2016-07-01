App = require '../../../../app'

{h1, a, p, div, li} = React.DOM

MessageView = React.createClass
  getClassName: (message) ->
    if message.get('show') 
      "message active #{message.get('type')}"
    else
      "message #{message.get('type')}"

  render:->
    {message} = @props
    div
      className: @getClassName(message)
      message.get('content')




module.exports = MessageView
