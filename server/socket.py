from . import app
from flask.ext.socketio import SocketIO, emit

socketio = SocketIO(app)
