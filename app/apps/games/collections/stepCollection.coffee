Step = require('../models/step')

class StepCollection extends Backbone.Collection
  model: Step
  
module.exports = StepCollection
