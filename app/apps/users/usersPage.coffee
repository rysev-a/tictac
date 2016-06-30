UsersView = require('./views/usersView')

class UsersPage
  constructor: (options)->
    @region = options.region
    _.extend(this, Backbone.Events)

  showUsersView: ()->
    element = React.createElement(UsersView)
    ReactDOM.render(element, document.getElementById(@region))

module.exports = UsersPage
