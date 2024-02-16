from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class IngredientStorage(BaseModel):
    id: int
    id_ingredient: int
    delivery_date: datetime
    id_request: int
    valid_until: datetime
    weight: Optional[float] = None
    quantity: int


class Ingredient(BaseModel):
    id: int
    name: str
    measurement: str
    price: Optional[float] = None
    critical_rate: int


class RequisitionList(BaseModel):
    id: int
    id_worker: int
    storage_name: str
    date: datetime
    status: str


class Requisition(BaseModel):
    id: int
    id_ingredient: int
    weight: Optional[float] = None
    quantity: int


class Storage(BaseModel):
    name: str
    address: str
    phone: str


class Worker(BaseModel):
    id: int
    job_role: str
    surname: str
    first_name: str
    patronymic: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    salary: float
    job_rate: Optional[float] = None


class JobRole(BaseModel):
    name: str
    min_salary: float
    max_salary: float


class WorkerHistory(BaseModel):
    id_worker: int
    start_date: datetime
    end_date: datetime
    id_job_role: str
    surname: str
    name: str
    patronymic: Optional[str] = None
    email: Optional[str] = None
    phone: str
    salary: float
    last_changes: Optional[str] = None


class FoodComposition(BaseModel):
    id_food: int
    id_ingredient: int
    weight: Optional[float] = None


class FoodType(BaseModel):
    type: str


class Food(BaseModel):
    id: int
    type: str
    name: str
    weight: Optional[float] = None
    unit_of_measurement: Optional[str] = None
    price: float


class OrderDirectory(BaseModel):
    id: int
    id_worker: int
    phone_client: str
    id_food: int
    formation_date: datetime
    giving_date: datetime
    status: str
    num_of_food: int


class Client(BaseModel):
    phone: str
    contact: str
    last_contact_date: datetime


class TableClient(BaseModel):
    id_table: int
    phone_client: str
    order_date: datetime
    desired_booking_date: datetime


class Table(BaseModel):
    id: int
    human_slots: int
