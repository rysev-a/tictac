from flask_admin import Admin
from flask.ext.admin.contrib.sqla import ModelView

from . import app
from .users.models import User
from .games.models import Game, Step
from .database import db_session
admin = Admin(app)


class UserAdmin(ModelView):
    column_list = ['login', 'email', 'active', 'password', 'online']
    form_columns = ['login', 'email', 'about', 'active', 'password']

admin.add_view(UserAdmin(User, db_session))
admin.add_view(ModelView(Game, db_session))
admin.add_view(ModelView(Step, db_session))

