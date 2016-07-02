Game = require('../models/game')

class GameCollection extends Backbone.Collection
  model: Game
  url: 'api/games'
  
module.exports = GameCollection
