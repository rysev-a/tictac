from flask_admin import Admin
from flask.ext.admin.contrib.sqla import ModelView

from . import app
from .users.models import User
from .database import db_session
admin = Admin(app)


class UserAdmin(ModelView):
    column_list = ['login', 'email', 'active']
    form_columns = ['login', 'email', 'about', 'active']

admin.add_view(UserAdmin(User, db_session))

