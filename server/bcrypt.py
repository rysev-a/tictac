from flask.ext.bcrypt import Bcrypt
from . import app
flask_bcrypt = Bcrypt(app)
