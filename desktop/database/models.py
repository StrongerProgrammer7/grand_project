from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Date, Float, ForeignKey

Base = declarative_base()  # базовый класс из SQA, от которого наследуются наши модели


class IngredientStorage(Base):
    __tablename__ = 'ingredient_storage'
    id = Column(Integer, primary_key=True)
    id_ingredient = Column(Integer, ForeignKey("ingredient.id"), nullable=False)        # Id ингредиента
    delivery_date = Column(Date, nullable=False)                                        # Когда пришел на склад
    id_request = Column(Integer, ForeignKey("requisition_list.id"), nullable=False)        # Id заявки
    valid_until = Column(Date)                                                          # Годен до:
    weight = Column(Float)                                                              # Вес
    quantity = Column(Integer, nullable=False)                                          # Количество на складе

    def __repr__(self):
        return ("<IngredientStorage(id_ingredient={}, delivery_date={}, id_request={},"
                " valid_until={}, weight={}, quantity={})>") \
            .format(self.id_ingredient, self.delivery_date, self.id_request,
                    self.valid_until, self.weight, self.quantity)


class Ingredient(Base):
    __tablename__ = 'ingredient'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    measurement = Column(String)                                                        # Единица измерения
    price = Column(Float)
    critical_rate = Column(Integer, nullable=False)                                     # Мало товара -> надо пополнить

    def __repr__(self):
        return "<Ingredient(name='{}', measurement='{}', price={}, critical_rate={})>" \
            .format(self.name, self.measurement, self.price, self.critical_rate)


class RequisitionList(Base):
    __tablename__ = 'requisition_list'
    id = Column(Integer, primary_key=True)
    id_worker = Column(Integer, ForeignKey("worker.id"), nullable=False)
    storage_name = Column(String, ForeignKey("storage.name"), nullable=False)
    date = Column(Date)
    status = Column(String)

    def __repr__(self):
        return "<RequisitionList(id_worker={}, storage_name='{}', date={}, status='{}')>" \
            .format(self.id_worker, self.storage_name, self.date, self.status)


# TODO: Вот тут (Requisition) не понятно куда что пихать (надо ждать пока допилят БД)
class Requisition(Base):
    __tablename__ = 'requisition'
    id = Column(Integer, primary_key=True)
    id_ingredient = Column(Integer, ForeignKey("ingredient.id"), nullable=False)        # Id ингредиента
    weight = Column(Float)                                                              # Вес
    quantity = Column(Integer, nullable=False)                                          # Количество в заявке

    def __repr__(self):
        return "<Requisition(id_ingredient={}, weight={}, quantity={})>" \
            .format(self.id_ingredient, self.weight, self.quantity)


class Storage(Base):
    __tablename__ = 'storage'
    name = Column(String, primary_key=True)
    address = Column(String)
    phone = Column(String)

    def __repr__(self):
        return "<Storage(address='{}', phone='{}')>" \
            .format(self.address, self.phone)


class Worker(Base):
    __tablename__ = 'worker'
    id = Column(Integer, primary_key=True)
    job_role = Column(Integer, ForeignKey("job_role.name"), nullable=False)
    surname = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    patronymic = Column(String)
    email = Column(String)
    phone = Column(String)
    salary = Column(Float, nullable=False)
    job_rate = Column(Float)

    def __repr__(self):
        return ("<Worker(job_role={}, surname={}, first_name={},"
                " patronymic={}, email={}, phone={}, salary={}, job_rate={})>") \
            .format(self.job_role, self.surname, self.first_name,
                    self.patronymic, self.email, self.phone, self.salary, self.job_rate)


class JobRole(Base):
    __tablename__ = 'job_role'
    name = Column(Integer, primary_key=True)
    min_salary = Column(Float)
    max_salary = Column(Float)

    def __repr__(self):
        return "<JobRole(min_salaty='{}', max_salaty='{}')>" \
            .format(self.min_salary, self.max_salaty)
