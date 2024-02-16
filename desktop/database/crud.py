from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from models import *
from desktop.database.config import DATABASE_URI
from file_manager.manager import YAML_work, JSON_work

engine = create_engine(DATABASE_URI,
                       connect_args={'client_encoding': 'utf8'},
                       pool_size=10,
                       max_overflow=20,
                       pool_pre_ping=True,
                       pool_recycle=3600, )
Session = sessionmaker(bind=engine, autocommit=False)


def recreate_database(db: Session):
    """
    Пересоздание базы данных. Предупреждение: удаляет все таблицы.
    """
    Base.metadata.drop_all(bind=db.bind)
    Base.metadata.create_all(bind=db.bind)
    print("Database recreated successfully")


def create_database(db: Session):
    """
    Создание таблиц базы данных.
    """
    Base.metadata.create_all(bind=db.bind)
    print("Database created successfully")


def select_row(model: Base, id: int, db: Session):
    """
    Общий метод для выбора строки по ID из базы данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        return db_row
    print(f"{model.__tablename__} not found")


def select_table(model: Base, db: Session):
    """
    Общий метод для выбора всех строк из таблицы базы данных.
    """
    return db.query(model).all()


def insert_row(model: Base, item: Base, db: Session):
    """
    Общий метод для вставки новой строки в базу данных.
    """
    db_item = model(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    print(f"{model.__tablename__} created successfully")


def insert_table(model: Base, items: list, db: Session):
    """
    Общий метод для вставки нескольких строк в базу данных.
    """
    db_items = [model(**item.dict()) for item in items]
    db.add_all(db_items)
    db.commit()
    print(f"All {model.__tablename__} created successfully")


def delete_row(model: Base, id: int, db: Session):
    """
    Общий метод для удаления строки по ID из базы данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        db.delete(db_row)
        db.commit()
        print(f"{model.__tablename__} deleted successfully")
    else:
        print(f"{model.__tablename__} not found")


def update_row(model: Base, id: int, updated_item: Base, db: Session):
    """
    Общий метод для обновления строки по ID в базе данных.
    """
    db_row = db.query(model).filter(model.id == id).first()
    if db_row:
        for key, value in updated_item.dict().items():
            setattr(db_row, key, value)
        db.commit()
        db.refresh(db_row)
        print(f"{model.__tablename__} updated successfully")
    else:
        print(f"{model.__tablename__} not found")


def add_from_file_in_table(model, strategy='JSON'):
    """
    :param model: класс из models.py, экземпляр которого создастся и запишется в БД
    :param strategy: тип файла из которого беруться данные таблицы. 'JSON', 'YAML'
    :return: None
    """
    if strategy == 'JSON':
        data = JSON_work.read()
    elif strategy == 'YAML':
        data = YAML_work.read()
    else:
        print('Выбранной стратегии не существует')
        return None

    ses = Session()
    for row in data:
        table_name = model(**row)
        ses.add(table_name)
    ses.commit()
    ses.close()
