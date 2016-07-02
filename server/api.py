from flask.ext.restful import Api
from . import app
from .users.resources import UserCurrent, UserList, UserLogin, UserLogout
from .games.resources import GameList

api = Api(app)
api.add_resource(UserList, '/api/users')
api.add_resource(UserCurrent, '/api/users/current')
api.add_resource(UserLogin, '/api/users/login')
api.add_resource(UserLogout, '/api/users/logout')

api.add_resource(GameList, '/api/games')
