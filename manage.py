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

if __name__ == '__main__':
    manager.run()


