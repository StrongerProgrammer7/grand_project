# CRUD — это аббревиатура от Create, Read, Update, and Delete.
# Сейчас является файлом запуска работы с БД

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from file_manager.manager import YAML_work, JSON_work
from desktop.database.config import DATABASE_URI
from models import Base, Ingredient

# Дает возможность создавать таблицы
engine = create_engine(DATABASE_URI, connect_args={'client_encoding': 'utf8'})
Session = sessionmaker(bind=engine)


# TODO: Не удаляет таблицы с зависимостями. Необходима функция DROP ... CASCADE
def recreate_database():
    Base.metadata.drop_all(engine)  # WARNING: Сносит все таблицы
    Base.metadata.create_all(engine)


def create_database():
    Base.metadata.create_all(engine)


"""
manager = JobRole(
    name='Менеджер',
    min_salary=27000,
    max_salary=34000
)
Дата в таком формате: datetime(2023, 2, 14)
"""


# TODO: Добавить запросы в БД
def add_one_in_table(row):
    ses = Session()
    ses.add(row)
    ses.commit()
    ses.close()


# TODO: Разбить данные в data файлах, чтобы можно было брать из них части так, чтобы не создавать много json'ов
def add_from_file_in_table(table, strategy='JSON'):
    """
    Пример использования: add_from_file_in_table(Ingredient)

    :param table: класс из models.py, экземпляр которого создастся и запишется в БД
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
        table_name = table(**row)
        ses.add(table_name)
    ses.commit()
    ses.close()


