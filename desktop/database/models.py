import datetime

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Date, Float, ForeignKey, Boolean, DateTime

Base = declarative_base()  # базовый класс из SQA, от которого наследуются наши модели


class IngredientStorage(Base):                                                          # Ингредиенты на складе
    __tablename__ = 'ingredient_storage'
    id = Column(Integer, primary_key=True, autoincrement=True)
    id_ingredient = Column(Integer, ForeignKey("ingredient.id"), nullable=False)        # Id ингредиента
    delivery_date = Column(DateTime(timezone=True), nullable=False)                                        # Когда пришел на склад
    id_request = Column(Integer, ForeignKey("requisition_list.id"), nullable=False)     # Id заявки
    valid_until = Column(DateTime(timezone=True), nullable=False)                                                          # Годен до:
    weight = Column(Float)                                                              # Вес
    quantity = Column(Integer, nullable=False)                                          # Количество на складе

    def __repr__(self):
        return ("<IngredientStorage(id_ingredient={}, delivery_date={}, id_request={},"
                " valid_until={}, weight={}, quantity={})>") \
            .format(self.id_ingredient, self.delivery_date, self.id_request,
                    self.valid_until, self.weight, self.quantity)


class Ingredient(Base):                                                                 # Ингредиент
    __tablename__ = 'ingredient'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False)
    measurement = Column(String(20), nullable=False)                                                        # Единица измерения
    price = Column(Float)
    critical_rate = Column(Integer, nullable=False)                                     # Мало товара -> надо пополнить

    def __repr__(self):
        return "<Ingredient(name='{}', measurement='{}', price={}, critical_rate={})>" \
            .format(self.name, self.measurement, self.price, self.critical_rate)


class RequisitionList(Base):                                                            # Список заявок
    __tablename__ = 'requisition_list'
    id = Column(Integer, primary_key=True, autoincrement=True)
    id_worker = Column(Integer, ForeignKey("worker.id"), nullable=False)
    storage_name = Column(String(50), ForeignKey("storage.name"), nullable=False)
    date = Column(DateTime(timezone=True), nullable=False, default=datetime.datetime.utcnow())
    status = Column(String(30), nullable=False)

    def __repr__(self):
        return "<RequisitionList(id_worker={}, storage_name='{}', date={}, status='{}')>" \
            .format(self.id_worker, self.storage_name, self.date, self.status)


# TODO: Вот тут (Requisition) не понятно куда что пихать (надо ждать пока допилят БД)
# Вроде должны быть такие связи ключей
class Requisition(Base):                                                                # Заявка ингредиента
    __tablename__ = 'requisition'
    id = Column(Integer, ForeignKey("requisition_list.id"), primary_key=True)
    id_ingredient = Column(Integer, ForeignKey("ingredient.id"), primary_key=True)      # Id ингредиента
    weight = Column(Float)                                                              # Вес
    quantity = Column(Integer, nullable=False)                                          # Количество в заявке

    def __repr__(self):
        return "<Requisition(id_ingredient={}, weight={}, quantity={})>" \
            .format(self.id_ingredient, self.weight, self.quantity)


class Storage(Base):                                                                    # Оптовый склад
    __tablename__ = 'storage'
    name = Column(String(50), primary_key=True)
    address = Column(String(255), nullable=False)
    phone = Column(String(20), nullable=False)

    def __repr__(self):
        return "<Storage(address='{}', phone='{}')>" \
            .format(self.address, self.phone)


class Worker(Base):                                                                     # Работник
    __tablename__ = 'worker'
    id = Column(Integer, primary_key=True, autoincrement=True)
    job_role = Column(String, ForeignKey("job_role.name"), nullable=False)
    surname = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    patronymic = Column(String(50))
    email = Column(String(255))
    phone = Column(String(20))
    salary = Column(Float, nullable=False)
    job_rate = Column(Float)

    def __repr__(self):
        return ("<Worker(job_role={}, surname={}, first_name={},"
                " patronymic={}, email={}, phone={}, salary={}, job_rate={})>") \
            .format(self.job_role, self.surname, self.first_name,
                    self.patronymic, self.email, self.phone, self.salary, self.job_rate)


class JobRole(Base):                                                                    # Должность
    __tablename__ = 'job_role'
    name = Column(String(50), primary_key=True)
    min_salary = Column(Float, nullable=False)
    max_salary = Column(Float, nullable=False)

    def __repr__(self):
        return "<JobRole(min_salaty='{}', max_salaty='{}')>" \
            .format(self.min_salary, self.max_salaty)

class WorkerHistory(Base):                                                              # История работника
    __tablename__ = 'worker_history'
    id_worker = Column(Integer, ForeignKey("worker.id"), primary_key=True)
    start_date = Column(DateTime(timezone=True), primary_key=True)                                         # Дата начала работы
    end_date = Column(DateTime(timezone=True), nullable=False)                                                             # Дата окончания работы
    id_job_role = Column(String(50), ForeignKey("job_role.name"), nullable=False)       # id должности
    surname = Column(String(50), nullable=False)
    name = Column(String(50), nullable=False)
    patronymic = Column(String(50))
    email = Column(String(255))
    phone = Column(String(20), nullable=False)
    salary = Column(Float, nullable=False)
    last_changes = Column(String)                                                       # Запись последних изменений

    def __repr__(self):
        return ("<WorkerHistory(start_date='{}', end_date='{}', id_job_role='{}',"
                "surname='{}', name='{}', patronymic='{}', email='{}',"
                "phone='{}', salary='{}', last_changes='{}')>") \
            .format(self.start_date, self.end_date, self.id_job_role, self.surname, self.name,
                    self.patronymic, self.email, self.phone, self.salary, self.last_changes)

class FoodComposition(Base):                                                            # Cостав
    __tablename__ = 'food_composition'
    id_food = Column(Integer, ForeignKey("food.id"), primary_key=True)                  # id блюда
    id_ingredient = Column(Integer, ForeignKey("ingredient.id"), primary_key=True)      # id ингредиента
    weight = Column(Float)                                                              # Объем/масса

    def __repr__(self):
        return ("<FoodComposition(id_food='{}', id_ingredient='{}',"
                "weight='{}')>") \
            .format(self.id_food, self.id_ingredient, self.weight)

class FoodType(Base):                                                                   # Тип блюда
    __tablename__ = 'food_type'
    type = Column(String(50), primary_key=True)                                         # id блюда

    def __repr__(self):
        return ("<FoodType(type='{}')>") \
            .format(self.type)

class Food(Base):                                                                       # Блюдо
    __tablename__ = 'food'
    id = Column(Integer, primary_key=True, autoincrement=True)                          # id блюда
    type = Column(String, ForeignKey("food_type.type"), nullable=False)
    name = Column(String, nullable=False)
    weight = Column(Float)
    unit_of_measurement = Column(String)                                                # единицы измерения
    price = Column(Float, nullable=False)

    def __repr__(self):
        return ("<Food(type='{}', name='{}',"
                "weight='{}', unit_of_measurement='{}', price='{}')>") \
            .format(self.type, self.name, self.weight,
                    self.unit_of_measurement, self.price)

class OrderDirectory(Base):                                                             # Справочник заказов
    __tablename__ = 'order_directory'
    id = Column(Integer, primary_key=True, autoincrement=True)
    id_worker = Column(Integer, ForeignKey("worker.id"), nullable=False)
    phone_client = Column(String(32), ForeignKey("client.phone"), nullable=False)                # ????
    id_food = Column(Integer, ForeignKey("food.id"), nullable=False)
    formation_date = Column(DateTime(timezone=True), nullable=False, default=datetime.datetime.utcnow())                                       # Дата формирования
    giving_date = Column(DateTime(timezone=True), nullable=False)                                          # Дата выдачи
    status = Column(String(50), default=True)
    num_of_food = Column(Integer, nullable=False)

    def __repr__(self):
        return ("<OrderDirectory(id_worker='{}', phone_client='{}',"
                "id_food='{}', formation_date='{}', giving_date='{}',"
                "status='{}', num_of_food='{}')>") \
            .format(self.id_worker, self.phone_client, self.id_food,
                    self.formation_date, self.giving_date, self.status, self. num_of_food)


class Client(Base):
    __tablename__ = 'client'
    phone = Column(String(32), primary_key=True)
    contact = Column(String(255), nullable=False)                                       # Как обращаться
    last_contact_date = Column(DateTime(timezone=True), nullable=False)                                    # Дата последнего обращения

    def __repr__(self):
        return ("<Client(phone='{}', contact='{}',"
                "last_contact_date='{}')>") \
            .format(self.phone, self.contact, self.last_contact_date)

class TableClient(Base):
    __tablename__ = 'client_table'
    id_table = Column(Integer, ForeignKey("table.id"), primary_key=True)
    phone_client = Column(String(32), ForeignKey("client.phone"), primary_key=True)
    order_date = Column(DateTime(timezone=True), nullable=False, default=datetime.datetime.utcnow())
    desired_booking_date = Column(DateTime(timezone=True), nullable=False)

    def __repr__(self):
        return ("<ClientTable(id_table='{}', phone_client='{}',"
                "order_date='{}', desired_booking_date='{}')>") \
            .format(self.id_table, self.phone_client, self.order_date, self.desired_booking_date)

class Table(Base):
    __tablename__ = 'table'
    id = Column(Integer, primary_key=True, autoincrement=True)
    human_slots = Column(Integer, nullable=False)

    def __repr__(self):
        return ("<Table(human_slots='{}')>") \
            .format(self.human_slots)

