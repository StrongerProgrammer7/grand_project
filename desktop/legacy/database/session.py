from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from config import *

engine = create_engine(DATABASE_URI,
                       connect_args={'client_encoding': 'utf8'},
                       pool_size=10,
                       max_overflow=20,
                       pool_pre_ping=True,
                       pool_recycle=3600)
Session = sessionmaker(bind=engine, autocommit=False)
