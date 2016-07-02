class Game extends Backbone.Model
  defaults:
    creator_id: undefined
    enemy_id: undefined
    steps: undefined
  url: 'api/games'

  sync: (method, model, options)->
    if method is 'read'
      options.url = "api/games/#{@.get('id')}"
    return Backbone.sync(method, model, options)




module.exports = Game
