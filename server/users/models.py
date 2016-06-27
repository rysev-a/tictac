from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Table
from sqlalchemy.ext.hybrid import hybrid_property

from ..database import Base

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True)
    email = Column(String(120), unique=True)
    _password = Column('passowrd', String(60))

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
