from flask.ext.restful import (Resource, reqparse, fields, 
                                marshal, marshal_with)
from flask.ext.login import current_user, login_user, logout_user
from flask import request, jsonify, json

from ..socket import socketio
from .models import Game, Step
from ..bcrypt import flask_bcrypt
from ..database import init_db, db_session

class GameListStatus(fields.Raw):
    def format(self, value):
        status_map = {
            0: 'created',
            1: 'in_progress',
            2: 'creator_win',
            3: 'enemy_win',
            4: 'reject'
        }
        return status_map.get(value)


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
    'status': GameListStatus
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

        return marshal(list([game]), game_fields)[0]


    def get(self):
        games = Game.query.filter_by(status=0)
        games = games.order_by(Game.id.desc())[:5]
        return marshal(list(games), game_fields), 200

    def put(self):
        game_id = request.get_json()['id']
        game = Game.query.filter_by(id=game_id)
        del request.json['creator']
        del request.json['enemy']
        game.update(request.json)
        db_session.commit()
        return {'message': 'ok'}, 200

class GameItem(Resource):
    def get(self, game_id):
        game = Game.query.get(game_id)
        if not game:
            return {'message': 'not found'}, 400

        return marshal(list([game]), game_fields)[0], 200


class StepList(Resource):
    def post(self):
        step_fields = {
            'id': fields.Integer,
            'master_id': fields.Integer,
            'x': fields.Integer,
            'y': fields.Integer
        }

        del request.json['side']
        step = Step(**request.json)
        db_session.add(step)
        db_session.commit()

        response = marshal(list([step]), step_fields)[0]
        socketio.emit('game:saveStep', response)

        return response
