App = require('../../../../app')
User = require('../models/user')
Message = require('../../../components/message/index')
ProfileView = require('../views/profileView')

class ProfilePage
  constructor: (options)->
    {@region} = options


  showProfileView: ()->
    element = React.createElement(ProfileView)
    ReactDOM.render(element, document.getElementById(@region))


module.exports = ProfilePage
