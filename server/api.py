from flask.ext.restful import Api
from . import app
from .users.resources import CurrentUser, UserList


api = Api(app)
api.add_resource(CurrentUser, '/users/current')
api.add_resource(UserList, '/users/')

