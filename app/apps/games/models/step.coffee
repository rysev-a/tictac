class Step extends Backbone.Model
  defaults:
    side: 'enemy'
    master_id: undefined
    x: undefined
    y: undefined
  url: 'api/steps'

module.exports = Step
