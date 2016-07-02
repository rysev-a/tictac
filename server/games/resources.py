from flask.ext.restful import Resource, reqparse, fields, marshal
from flask.ext.login import current_user, login_user, logout_user
from flask import request, jsonify, json

from .models import Game
from ..bcrypt import flask_bcrypt
from ..database import init_db, db_session


class GameList(Resource):
    def post(self):
        data = request.json
        game = Game(**data)
        db_session.add(game)
        db_session.commit()

        return marshal(list([game]), game_fields)[0]


    def get(self):
        games = Game.query.all()

        step_fields = {
            'id': fields.Integer,
            'creator_id': fields.Integer,
            'enemy_id' : fields.Integer
        }


        game_fields = {
            'creator_id': fields.Integer,
            'enemy_id' : fields.Integer
            #'steps': fields.List(fields.Nested(step_fields))
        }

        return marshal(list(games), games_fields), 200

