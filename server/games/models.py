from sqlalchemy import Column, Integer, Boolean, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Table
from sqlalchemy.ext.hybrid import hybrid_property


from ..database import db_session
from ..database import Base


class Step(Base):
    __tablename__ = 'steps'
    id = Column(Integer, primary_key=True)
    creator_id = Column(Integer, ForeignKey('users.id'))
    creator = relationship('User', foreign_keys=[creator_id])    
    enemy_id = Column(Integer, ForeignKey('users.id'))
    enemy = relationship('User', foreign_keys=[enemy_id])
    game_id = Column(Integer, ForeignKey('games.id'))
    game = relationship('Game', foreign_keys=[game_id])    

class Game(Base):
    __tablename__ = 'games'
    id = Column(Integer, primary_key=True)
    creator_id = Column(Integer, ForeignKey('users.id'))
    creator = relationship('User', foreign_keys=[creator_id])    
    enemy_id = Column(Integer, ForeignKey('users.id'))
    enemy = relationship('User', foreign_keys=[enemy_id])
    steps = relationship("Step", 
        primaryjoin="Game.id==Step.game_id")

    def __repr__(self):
        return '%s vs %s' % (self.creator.login, self.enemy.login)
