from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base


from . import settings

engine = create_engine(settingsTpl.format(settings.DATABASE), 
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
