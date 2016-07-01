MessageView = require('./views/messageView')
MessageModel = require('./models/message')

class MessageComponent
  constructor: ({content, type='success'})->
    @region = 'message'
    @message = new MessageModel
      content: content
      type:    type

    @showMessageView()
    @message.on('change:show', @showMessageView.bind(this))
    setTimeout (()=> @message.set('show', true)), 100
    setTimeout (()=> @message.set('show', false)), 3000

    _.extend(this, Backbone.Events)

  showMessageView: ()->
    element = React.createElement(MessageView, message: @message)
    ReactDOM.render(element, document.getElementById(@region))

module.exports = MessageComponent
