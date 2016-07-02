Link = require('../models/link')

class LinkCollection extends Backbone.Collection
  model: Link
  visibled: ()->
    visibled = @filter( (link)->
      link.get('visible')
    )
    new LinkCollection(visibled)

module.exports = LinkCollection
