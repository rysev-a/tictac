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
  toJSON:->
    enemy_id = @.get('enemy_id')
    enemy_id  = undefined if enemy_id is 0
    id: @.get('id')
    creator_id: @.get('creator_id')
    enemy_id: enemy_id
    status: @.get('status')



module.exports = Game
