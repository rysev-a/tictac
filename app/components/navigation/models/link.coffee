class Link extends Backbone.Model
  setActive: ->
    @collection.map (link)->
      link.set('active', false)
    @.set('active', true)

  defaults:
    active: false
    visible: true

module.exports = Link
