# Create, Read, Update, Delete
from fastapi import HTTPException
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.ext.declarative import declarative_base

import settings
from models import *

# -------------- Подключение -------------- #
engine = create_engine(settings.DATABASE_URI,
                       connect_args={'client_encoding': 'utf8'},
                       pool_size=10,
                       max_overflow=20,
                       pool_pre_ping=True,
                       pool_recycle=3600)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()  # базовый класс из SQA, от которого наследуются наши модели


# //////////////////////////////////////////// Универсальные методы //////////////////////////////////////////// #

# Dependency для получения сессии базы данных
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def recreate_database():
    """
    Пересоздание базы данных. Предупреждение: удаляет все таблицы.
    """
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    return {"message": "Database recreated successfully"}


def create_database():
    """
    Создание таблиц базы данных.
    """
    Base.metadata.create_all(bind=engine)
    return {"message": "Database created successfully"}


def select_row(model: BaseModel, id: int, db: Session):
    """
    Общий метод для выбора строки по ID из базы данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        return db_row
    raise HTTPException(status_code=404, detail=f"{model.__name__} not found")


def select_table(model: BaseModel, db: Session):
    """
    Общий метод для выбора всех строк из таблицы базы данных.
    """
    return db.query(model).all()


def insert_row(model: BaseModel, item: BaseModel, db: Session):
    """
    Общий метод для вставки новой строки в базу данных.
    """
    db_item = model(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return {"message": f"{model.__name__} created successfully"}


def insert_table(model: BaseModel, items: list, db: Session):
    """
    Общий метод для вставки нескольких строк в базу данных.
    """
    db_items = [model(**item.dict()) for item in items]
    db.add_all(db_items)
    db.commit()
    return {"message": f"All {model.__name__} created successfully"}


def delete_row(model: BaseModel, id: int, db: Session):
    """
    Общий метод для удаления строки по ID из базы данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        db.delete(db_row)
        db.commit()
        return {"message": f"{model.__name__} deleted successfully"}
    raise HTTPException(status_code=404, detail=f"{model.__name__} not found")


def update_row(model: BaseModel, id: int, updated_item: BaseModel, db: Session):
    """
    Общий метод для обновления строки по ID в базе данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        for key, value in updated_item.dict().items():
            setattr(db_row, key, value)
        db.commit()
        db.refresh(db_row)
        return {"message": f"{model.__name__} updated successfully"}
    raise HTTPException(status_code=404, detail=f"{model.__name__} not found")
