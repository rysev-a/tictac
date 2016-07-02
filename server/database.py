from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

engine = create_engine('postgresql://postgres:alex88@localhost:5432/tictac', 
    pool_size=20, max_overflow=100)
db_session = scoped_session(sessionmaker(autocommit=False,
                                        autoflush=False,
                                        bind=engine))

Base = declarative_base()
Base.query = db_session.query_property()

def init_db():
    from .users import models as user_models
    from .games import models as user_models
    Base.metadata.create_all(bind=engine)
