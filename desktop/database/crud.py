# CRUD — это аббревиатура от Create, Read, Update, and Delete.
# Сейчас является файлом запуска работы с БД
import datetime

from sqlalchemy import create_engine, insert
from sqlalchemy.orm import sessionmaker

from desktop.database import models
from desktop.database.config import DATABASE_URI
from file_manager.manager import YAML_work, JSON_work
from models import Base

# Дает возможность создавать таблицы
engine = create_engine(DATABASE_URI, connect_args={'client_encoding': 'utf8'})
Session = sessionmaker(bind=engine)


def recreate_database():
    Base.metadata.drop_all(engine)  # WARNING: Сносит все таблицы
    engine.echo = True  # Консольные логи SQLAlchemy
    Base.metadata.create_all(engine)


def create_database():
    Base.metadata.create_all(engine)


def add_one_in_table(row):
    ses = Session()
    ses.add(row)
    ses.commit()
    ses.close()


# TODO: Разбить данные в data файлах, чтобы можно было брать из них части так, чтобы не создавать много json'ов
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


def select_one_from_table(model):
    """
    :param model: класс из models.py, экземпляр которого создастся и запишется в БД
    :return: row
    """
    ses = Session()
    return ses.query(model).first()


def select_all_from_table(model):
    """
    :param model: класс из models.py, экземпляр которого создастся и запишется в БД
    :return: table
    """
    ses = Session()
    return ses.query(model).all()


def insert_test_data():
    session = Session()

    table1 = models.Table(human_slots=4)
    table2 = models.Table(human_slots=3)
    table3 = models.Table(human_slots=2)
    table4 = models.Table(human_slots=5)

    client1 = models.Client(phone="+79389513658", contact="Константин",
                            last_contact_date=datetime.datetime.utcnow().replace(microsecond=0))
    client2 = models.Client(phone="+79637259702", contact="Валентин",
                            last_contact_date=datetime.datetime.utcnow().replace(microsecond=0))
    client3 = models.Client(phone="+79848718618", contact="Анатолий",
                            last_contact_date=datetime.datetime.utcnow().replace(microsecond=0))
    client4 = models.Client(phone="+79330339678", contact="Глеб",
                            last_contact_date=datetime.datetime.utcnow().replace(microsecond=0))

    tableclient1 = models.TableClient(id_table=1, phone_client="+79389513658",
                                      order_date=datetime.datetime.utcnow().replace(microsecond=0),
                                      desired_booking_date=datetime.datetime.utcnow().replace(microsecond=0))
    tableclient2 = models.TableClient(id_table=2, phone_client="+79637259702",
                                      order_date=datetime.datetime.utcnow().replace(microsecond=0),
                                      desired_booking_date=datetime.datetime.utcnow().replace(microsecond=0))
    tableclient3 = models.TableClient(id_table=3, phone_client="+79848718618",
                                      order_date=datetime.datetime.utcnow().replace(microsecond=0),
                                      desired_booking_date=datetime.datetime.utcnow().replace(microsecond=0))
    tableclient4 = models.TableClient(id_table=4, phone_client="+79330339678",
                                      order_date=datetime.datetime.utcnow().replace(microsecond=0),
                                      desired_booking_date=datetime.datetime.utcnow().replace(microsecond=0))

    job_role1 = models.JobRole(name="Старший Повар", min_salary=70000, max_salary=80000)
    job_role2 = models.JobRole(name="Младший Повар", min_salary=40000, max_salary=60000)
    job_role3 = models.JobRole(name="Шеф-Повар", min_salary=2000000, max_salary=5000000)
    job_role4 = models.JobRole(name="Официант", min_salary=30000, max_salary=40000)

    worker1 = models.Worker(job_role="Старший Повар", surname="Прохвостин", first_name="Михаил", patronymic="",
                            phone="+79028759088", salary=50000)
    worker2 = models.Worker(job_role="Младший Повар", surname="Александров", first_name="Олег", patronymic="",
                            phone="+79028759088", salary=50000)
    worker3 = models.Worker(job_role="Шеф-Повар", surname="Васильев", first_name="Михаил", patronymic="",
                            phone="+79028759088", salary=50000)
    worker4 = models.Worker(job_role="Официант", surname="Иванов", first_name="Олег", patronymic="",
                            phone="+79028759088", salary=50000)

    worker_history1 = models.WorkerHistory(id_worker=1, start_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           end_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           id_job_role="Шеф-Повар", surname="Александров", name="Олег",
                                           phone="+79637259702", salary=50000)
    worker_history2 = models.WorkerHistory(id_worker=2, start_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           end_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           id_job_role="Младший Повар", surname="Васильев", name="Олег",
                                           phone="+79637259702", salary=30000)
    worker_history3 = models.WorkerHistory(id_worker=3, start_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           end_date=datetime.datetime.utcnow().replace(microsecond=0),
                                           id_job_role="Младший Повар", surname="Иванов", name="Михаил",
                                           phone="+79637259702", salary=60000)

    food_type1 = models.FoodType(type="Пицца")
    food_type2 = models.FoodType(type="Суши")
    food_type3 = models.FoodType(type="Салаты")
    food_type4 = models.FoodType(type="Напитки")

    food1 = models.Food(type="Напитки", name="Бурбон", weight=200, unit_of_measurement="Грамм", price=300)
    food2 = models.Food(type="Пицца", name="Карбонара", weight=800, unit_of_measurement="Грамм", price=800)
    food3 = models.Food(type="Салаты", name="Цезарь", weight=400, unit_of_measurement="Грамм", price=600)

    order_directory1 = models.OrderDirectory(id_worker=1, phone_client="+79389513658", id_food=1,
                                             formation_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             giving_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             status="Готовится", num_of_food=2)
    order_directory2 = models.OrderDirectory(id_worker=2, phone_client="+79637259702", id_food=2,
                                             formation_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             giving_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             status="Подано", num_of_food=1)
    order_directory3 = models.OrderDirectory(id_worker=3, phone_client="+79848718618", id_food=3,
                                             formation_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             giving_date=datetime.datetime.utcnow().replace(microsecond=0),
                                             status="Готовится", num_of_food=4)

    ingredient1 = models.Ingredient(name="Помидоры", measurement="кг", price=200, critical_rate=5)
    ingredient2 = models.Ingredient(name="Огурцы", measurement="кг", price=100, critical_rate=3)
    ingredient3 = models.Ingredient(name="Мука", measurement="кг", price=50, critical_rate=5)

    food_composition1 = models.FoodComposition(id_food=1, id_ingredient=2, weight=300)
    food_composition2 = models.FoodComposition(id_food=2, id_ingredient=3, weight=500)
    food_composition3 = models.FoodComposition(id_food=3, id_ingredient=1, weight=700)

    storage1 = models.Storage(name="Сундук", address="Краснодар", phone="+79057474162")
    storage2 = models.Storage(name="Рундук", address="Ростов", phone="+79943211287")
    storage3 = models.Storage(name="Ларец", address="Москва", phone="+79279675440")

    requisition_list1 = models.RequisitionList(id_worker=1, storage_name="Сундук",
                                               date=datetime.datetime.utcnow().replace(microsecond=0),
                                               status="В процессе")
    requisition_list2 = models.RequisitionList(id_worker=2, storage_name="Рундук",
                                               date=datetime.datetime.utcnow().replace(microsecond=0),
                                               status="Выполнено")
    requisition_list3 = models.RequisitionList(id_worker=3, storage_name="Ларец",
                                               date=datetime.datetime.utcnow().replace(microsecond=0),
                                               status="В процессе")

    requisition1 = models.Requisition(id=1, id_ingredient=2, weight=2, quantity=30)
    requisition2 = models.Requisition(id=2, id_ingredient=1, weight=3, quantity=40)
    requisition3 = models.Requisition(id=3, id_ingredient=3, weight=10, quantity=50)

    ingredient_storage1 = models.IngredientStorage(id_ingredient=1,
                                                   delivery_date=datetime.datetime.utcnow().replace(microsecond=0),
                                                   id_request=1,
                                                   valid_until=datetime.datetime.utcnow().replace(microsecond=0),
                                                   weight=10, quantity=300)
    ingredient_storage2 = models.IngredientStorage(id_ingredient=2,
                                                   delivery_date=datetime.datetime.utcnow().replace(microsecond=0),
                                                   id_request=2,
                                                   valid_until=datetime.datetime.utcnow().replace(microsecond=0),
                                                   weight=1, quantity=654)
    ingredient_storage3 = models.IngredientStorage(id_ingredient=3,
                                                   delivery_date=datetime.datetime.utcnow().replace(microsecond=0),
                                                   id_request=3,
                                                   valid_until=datetime.datetime.utcnow().replace(microsecond=0),
                                                   weight=3, quantity=700)

    args = [table1, table2, table3, table4, client1, client2, client3, client4, tableclient1, tableclient2,
            tableclient3, tableclient4, job_role1, job_role2, job_role3, job_role4, worker1, worker2, worker3, worker4,
            worker_history1, worker_history2, worker_history3, food_type1, food_type2, food_type3, food_type4, food1,
            food2, food3, order_directory1, order_directory2, order_directory3, ingredient1, ingredient2, ingredient3,
            food_composition1, food_composition2, food_composition3, storage1, storage2, storage3, requisition_list1,
            requisition_list2, requisition_list3, requisition1, requisition2, requisition3, ingredient_storage1,
            ingredient_storage2, ingredient_storage3]

    for key, args in enumerate(args):
        session.add(args)
        session.commit()

    session.close()


# //////////////////////////////////////////////////////////////////
# recreate_database()
# engine.echo = False  # Консольные логи SQLAlchemy
#
# insert_test_data()
# //////////////////////////////////////////////////////////////////

for item in select_all_from_table(models.Worker):
    print(item)

# //////////////////////////////////////////////////////////////////
# with engine.connect() as conn:
#     result = conn.execute(
#         insert(models.FoodType),
#         [
#             {"type": "Пицца"},
#             {"type": "Суши"},
#             {"type": "Салат"}
#         ]
#     )
#     conn.commit()
# //////////////////////////////////////////////////////////////////
