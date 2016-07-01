from sqlalchemy import Column, Integer, Boolean, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Table
from sqlalchemy.ext.hybrid import hybrid_property


from wtforms import StringField
from wtforms.validators import DataRequired
from wtforms_alchemy.validators import Unique
from wtforms_alchemy import ModelForm

from ..database import db_session
from ..bcrypt import flask_bcrypt
from ..database import Base

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    login = Column(String(50), unique=True)
    about = Column(String(50))
    active = Column(Boolean)
    email = Column(String(120), unique=True, nullable=False)

    _password = Column('passowrd', String(200))

    @hybrid_property
    def password(self):
        return self._password

    @password.setter
    def password(self, password):
        self._password = flask_bcrypt.generate_password_hash(password)

    # def __init__(self, name=None, email=None):
    #     self.name = name
    #     self.email = email

    def __repr__(self):
        return '%s: %s' % (self.name, self.email)


    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return str(self.id)

class UserForm(ModelForm):
    login = StringField('login', validators=[DataRequired(), Unique(User.login)])
    email = StringField('email', validators=[DataRequired(), Unique(User.email)])
    password = StringField('pasword', validators=[DataRequired()])
