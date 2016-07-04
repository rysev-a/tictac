from flask.ext.restful import (Resource, reqparse, fields, 
                                marshal, marshal_with)
from flask.ext.login import current_user, login_user, logout_user
from flask import request, jsonify, json

from ..socket import socketio
from .models import Game, Step
from ..bcrypt import flask_bcrypt
from ..database import init_db, db_session

user_fields = {
    'id': fields.Integer,
    'login': fields.String
}

game_fields = {
    'id': fields.Integer,
    'creator' : fields.Nested(user_fields),
    'enemy' : fields.Nested(user_fields),
    'creator_id': fields.Integer,
    'enemy_id': fields.Integer,
    'status': fields.Integer
}

class GameList(Resource):
    def post(self):
        game_fields = {
            'id': fields.Integer,
            'creator_id': fields.Integer,
            'enemy_id' : fields.Integer
        }

        data = request.json
        game = Game(**data)
        db_session.add(game)
        db_session.commit()
        response = marshal(list([game]), game_fields)[0]
        socketio.emit('game:updateGameList', response)
        return response


    def get(self):
        games = Game.query.filter_by(status=0).order_by(Game.id.desc())[:5]
        # games = Game.query.all()
        return marshal(list(games), game_fields), 200

    def put(self):
        game_id = request.get_json()['id']
        status = request.get_json()['status']
        game = Game.query.filter_by(id=game_id)
        data = request.json

        game.update(data)
        db_session.commit()

        game = Game.query.get(game_id)
        response = marshal(list([game]), game_fields)[0], 200

        socketio.emit('game:update', response)
        socketio.emit('game:updateGameList', response)
        return {'message': 'ok'}, 200

class GameItem(Resource):
    def get(self, game_id):
        game = Game.query.get(game_id)
        if not game:
            return {'message': 'not found'}, 400

        step_fields = {
            'id': fields.Integer,
            'master_id': fields.Integer,
            'x': fields.Integer,
            'y': fields.Integer
        }

        game_fields = {
            'id': fields.Integer,
            'creator' : fields.Nested(user_fields),
            'enemy' : fields.Nested(user_fields),
            'creator_id': fields.Integer,
            'enemy_id': fields.Integer,
            'status': fields.Integer,
            'steps': fields.List(fields.Nested(step_fields))
        }

        return marshal(list([game]), game_fields)[0], 200


class StepList(Resource):
    def post(self):
        step_fields = {
            'id': fields.Integer,
            'master_id': fields.Integer,
            'x': fields.Integer,
            'y': fields.Integer,
            'game_id': fields.Integer
        }

        del request.json['side']
        step = Step(**request.json)
        db_session.add(step)
        db_session.commit()

        response = marshal(list([step]), step_fields)[0]
        socketio.emit('game:saveStep', response)

        return response
