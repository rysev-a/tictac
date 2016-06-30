class Link extends Backbone.Model
  setActive: ->
    @collection.map (link)->
      link.set('active', false)
    @.set('active', true)

  defaults:
    active: false

module.exports = Link
