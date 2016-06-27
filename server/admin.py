from flask_admin import Admin
from flask.ext.admin.contrib.sqla import ModelView

from . import app
from .users.models import User
from .database import db_session
admin = Admin(app)
admin.add_view(ModelView(User, db_session))

