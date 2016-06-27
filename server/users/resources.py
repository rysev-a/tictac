from flask.ext.restful import Resource, reqparse, fields, marshal
from flask.ext.login import current_user

from .models import User

class CurrentUser(Resource):
    def get(self):
        print(current_user)
        if not current_user.is_authenticated:
            return {'error': 'authorization required'}, 401
        return {
            'status': 'success', 
            'message': {
                'id': current_user.id,
                'name': current_user.name,
                'email': current_user.email
            }
        }

class UserList(Resource):
    def get(self):
        if not current_user.is_authenticated:
            return {'error': 'authorization required'}, 401
        user_fields = {
            'id': fields.Integer,
            'name' : fields.String,
            'email': fields.String
        }
        users = User.query.all()
        return marshal(list(users), user_fields), 200
