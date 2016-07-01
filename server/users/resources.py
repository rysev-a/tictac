from flask.ext.restful import Resource, reqparse, fields, marshal
from flask.ext.login import current_user
from flask import request, jsonify, json

from .models import User, UserForm
from ..database import init_db, db_session

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
    def post(self):
        data = request.json
        form = UserForm(**data)

        if not form.validate():
            response = jsonify(form.errors)
            response.status_code = 409
            return response

        print(data)
        # userForm = UserForm(**data)
        # validate = userForm.validate()
        #db_session.add(user)
        #db_session.commit()

        return {'message': 'success'}, 200

        user_fields = {
            'login' : fields.String,
            'email': fields.String
        }
        return marshal(list([user]), user_fields)[0]


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
