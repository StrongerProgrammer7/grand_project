# CRUD — это аббревиатура от Create, Read, Update, and Delete.

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from desktop.database.config import DATABASE_URI
from models import Base

# Дает возможность создавать таблицы
engine = create_engine(DATABASE_URI, connect_args={'client_encoding': 'utf8'})
Session = sessionmaker(bind=engine)


# TODO: Не удаляет таблицы с зависимостями. Необходима функция DROP ... CASCADE
def recreate_database():
    Base.metadata.drop_all(engine)  # WARNING: Сносит все таблицы
    Base.metadata.create_all(engine)


def create_database():
    Base.metadata.create_all(engine)


# TODO: Добавить работу по добавлению данных в таблицы. Экземпляры для добавления создавать в другом файле. Вид:
"""
manager = JobRole(
    name='Менеджер',
    min_salary=27000,
    max_salary=34000
)
Дата в таком формате: datetime(2023, 2, 14)
"""


def add_in_table(element):
    s = Session()
    s.add(element)
    s.commit()
    s.close()

# TODO: Добавить запросы в БД


create_database()
