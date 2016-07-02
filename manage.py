#-*- coding: utf-8 -*-
import sys, os, subprocess
import os.path as op
import json
import sqlalchemy

from flask.ext.script import Manager
from server import app
from server.database import init_db, db_session
from server.bcrypt import flask_bcrypt
from server.users.models import User
from server.games.models import Game, Step

manager = Manager(app)


@manager.command
def initapp():
    init_db()
    drop_steps()
    drop_games()
    drop_users()
    create_users()
    create_games()
    runserver()

@manager.command
def runserver():
    from server import app
    from server.socket import socketio
    if __name__ == '__main__':

        extra_dirs = ['directory/to/watch',]
        extra_files = extra_dirs[:]
        for extra_dir in extra_dirs:
            for dirname, dirs, files in os.walk(extra_dir):
                for filename in files:
                    filename = path.join(dirname, filename)
                    if path.isfile(filename):
                        extra_files.append(filename)

        app.extra_files=extra_files
        socketio.run(app)

@manager.command
def drop_users():
    for user in User.query.all():
        db_session.delete(user)
    db_session.commit()

@manager.command
def create_users():
    logins = [
        'alex', 
        'vova',
        'katya'
    ]

    for login in logins:
        new_user = User(
            login=login,
            email=login + '@mail.ru',
            about=login,
            password = '123'
        )
        db_session.add(new_user)
    db_session.commit()


@manager.command
def drop_games():
    games = Game.query.all()
    for game in games:
        db_session.delete(game)
    db_session.commit()

@manager.command
def create_games():

    new_game = Game(
        creator_id=User.query.all()[0].id,
        enemy_id=User.query.all()[1].id
    )
    db_session.add(new_game)
    db_session.commit()

@manager.command
def drop_steps():
    steps = Step.query.all()
    for step in steps:
        db_session.delete(step)
    db_session.commit()

if __name__ == '__main__':
    manager.run()


