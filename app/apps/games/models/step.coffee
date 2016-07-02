class Step extends Backbone.Model
  defaults:
    side: undefined
    master_id: undefined
    x: undefined
    y: undefined
  url: 'api/steps'


module.exports = Step
