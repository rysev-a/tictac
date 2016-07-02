from sqlalchemy import Column, Integer, Boolean, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Table
from sqlalchemy.ext.hybrid import hybrid_property


from ..database import db_session
from ..database import Base


class Step(Base):
    __tablename__ = 'steps'
    id = Column(Integer, primary_key=True)
    master_id = Column(Integer, ForeignKey('users.id'))
    master = relationship('User', foreign_keys=[master_id])
    x = Column(Integer)
    y = Column(Integer)
    game_id = Column(Integer, ForeignKey('games.id'))
    game = relationship('Game', foreign_keys=[game_id])

    def __repr__(self):
        return self.id

class Game(Base):
    __tablename__ = 'games'
    id = Column(Integer, primary_key=True)
    creator_id = Column(Integer, ForeignKey('users.id'))
    creator = relationship('User', foreign_keys=[creator_id])    
    enemy_id = Column(Integer, ForeignKey('users.id'), nullable=True)
    enemy = relationship('User', foreign_keys=[enemy_id])
    steps = relationship("Step", 
        primaryjoin="Game.id==Step.game_id")
    status = Column(Integer, default=0)

    def get_status(self):
        status_map = {
            0: 'created',
            1: 'in_progress',
            2: 'creator_win',
            3: 'enemy_win',
            4: 'reject'
        }

        return status_map[self.status]

    def __repr__(self):
        if self.enemy:
            return '%s vs %s' % (self.creator.login, self.enemy.login)
        else:
            return '%s vs waitiong' % (self.creator.login)
