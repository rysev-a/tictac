from server import app
from server.socket import socketio
if __name__ == '__main__':
    socketio.run(app)
