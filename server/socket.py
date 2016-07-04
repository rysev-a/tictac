from . import app
from flask.ext.socketio import SocketIO, emit, join_room

socketio = SocketIO(app)

print('init socket')

@socketio.on('join')
def on_join(data):
    room = data['room']
    join_room(room)
