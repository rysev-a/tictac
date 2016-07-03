#-*- coding: utf-8 -*-
import sys, os, subprocess
import os.path as op
import json
import sqlalchemy

from flask.ext.script import Manager
from server import app
from server.database import init_db, db_session, engine
from server.bcrypt import flask_bcrypt
from server.users.models import User
from server.games.models import Game, Step

manager = Manager(app)


@manager.command
def initapp():
    clear_db()
    init_db()
    create_users()
    #create_games()
    runserver()

@manager.command
def runserver():
    from server import app
    from server.socket import socketio
    if __name__ == '__main__':

        # extra_dirs = ['directory/to/watch',]
        # extra_files = extra_dirs[:]
        # for extra_dir in extra_dirs:
        #     for dirname, dirs, files in os.walk(extra_dir):
        #         for filename in files:
        #             filename = path.join(dirname, filename)
        #             if path.isfile(filename):
        #                 extra_files.append(filename)

        # app.extra_files=extra_files
        socketio.run(app)

@manager.command
def clear_db():
    Step.__table__.drop(engine, checkfirst=True)
    Game.__table__.drop(engine, checkfirst=True)
    User.__table__.drop(engine, checkfirst=True)

@manager.command
def create_users():
    logins = ['alex', 'vova', 'alina']

    for login in logins:
        user = User(
            login=login, 
            email=login + '@mail.ru', 
            password = '123'
        )
        db_session.add(user)
    db_session.commit()

@manager.command
def create_games():
    for item in range(0,10):
        if item % 2 == 0:
            game = Game(
                creator_id=User.query.all()[0].id
            )
            db_session.add(game)
        else:
            game = Game(
                creator_id=User.query.all()[1].id
            )
            db_session.add(game)
    db_session.commit()


if __name__ == '__main__':
    manager.run()


