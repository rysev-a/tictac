#-*- coding: utf-8 -*-
import sys, os, subprocess
import os.path as op
import json

from flask.ext.script import Manager
from server import app
from server.database import init_db, db_session
from server.users.models import User

manager = Manager(app)

@manager.command
def init_app():
    init_db()
    print('successful create db')


@manager.command
def runserver():
    from server import app
    from server.socket import socketio
    if __name__ == '__main__':
        socketio.run(app)

if __name__ == '__main__':
    manager.run()


