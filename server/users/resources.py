from flask.ext.restful import Resource, reqparse, fields, marshal
from flask.ext.login import current_user, login_user, logout_user
from flask import request, jsonify, json

from .models import User, UserForm
from ..bcrypt import flask_bcrypt
from ..database import init_db, db_session

class UserCurrent(Resource):
    def get(self):
        if not current_user.is_authenticated:
            return {'error': 'authorization required'}, 401
        return {
            'id':    current_user.id,
            'login': current_user.login,
            'email': current_user.email
        }, 200

class UserLogin(Resource):
    def post(self):
        email = request.get_json()['email']
        password = request.get_json()['password']

        user = User.query.filter_by(email=email).first()

        if not user:
            return {'message': 'Invalid email'}, 400


        if(not flask_bcrypt.check_password_hash(user.password, password)):
            return {'message': 'Invalid password'}, 400        

        login_user(user, remember=True)
        return {'message': 'login success'}, 200

class UserLogout(Resource):
    def post(self):
        logout_user()
        return {'message': 'logout success'}, 200

class UserList(Resource):
    def post(self):
        data = request.json
        form = UserForm(**data)

        if not form.validate():
            response = jsonify(form.errors)
            response.status_code = 400
            return response


        user = User(**data)
        db_session.add(user)
        db_session.commit()
        login_user(user, remember=True)

        user_fields = {
            'login' : fields.String,
            'email': fields.String,
            'about': fields.String
        }
        return marshal(list([user]), user_fields)[0], 201


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

