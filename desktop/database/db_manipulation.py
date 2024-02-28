# Скрипт для управления данными БД
from datetime import datetime
from crud import *
from models import *
from session import *


def insert_test_data(db: Session):
    try:
        # Recreate the database
        recreate_database(db)

        # Create tables
        create_database(db)

        data = {
            Table: [
                {"human_slots": 4},
                {"human_slots": 3},
                {"human_slots": 2},
                {"human_slots": 5}
            ],
            Client: [
                {"phone": "+79389513658", "contact": "Константин", "last_contact_date": datetime.utcnow()},
                {"phone": "+79637259702", "contact": "Валентин", "last_contact_date": datetime.utcnow()},
                {"phone": "+79848718618", "contact": "Анатолий", "last_contact_date": datetime.utcnow()},
                {"phone": "+79330339678", "contact": "Глеб", "last_contact_date": datetime.utcnow()}
            ],
            TableClient: [
                {"id_table": 1, "phone_client": "+79389513658", "order_date": datetime.utcnow(),
                 "desired_booking_date": datetime.utcnow()},
                {"id_table": 2, "phone_client": "+79637259702", "order_date": datetime.utcnow(),
                 "desired_booking_date": datetime.utcnow()},
                {"id_table": 3, "phone_client": "+79848718618", "order_date": datetime.utcnow(),
                 "desired_booking_date": datetime.utcnow()},
                {"id_table": 4, "phone_client": "+79330339678", "order_date": datetime.utcnow(),
                 "desired_booking_date": datetime.utcnow()}
            ],
            JobRole: [
                {"name": "Старший Повар", "min_salary": 70000, "max_salary": 80000},
                {"name": "Младший Повар", "min_salary": 40000, "max_salary": 60000},
                {"name": "Шеф-Повар", "min_salary": 2000000, "max_salary": 5000000},
                {"name": "Официант", "min_salary": 30000, "max_salary": 40000}
            ],
            Worker: [
                {"job_role": "Старший Повар", "surname": "Прохвостин", "first_name": "Михаил", "patronymic": "",
                 "phone": "+79028759088", "salary": 50000},
                {"job_role": "Младший Повар", "surname": "Александров", "first_name": "Олег", "patronymic": "",
                 "phone": "+79028759088", "salary": 50000},
                {"job_role": "Шеф-Повар", "surname": "Васильев", "first_name": "Михаил", "patronymic": "",
                 "phone": "+79028759088", "salary": 50000},
                {"job_role": "Официант", "surname": "Иванов", "first_name": "Олег", "patronymic": "",
                 "phone": "+79028759088", "salary": 50000}
            ],
            WorkerHistory: [
                {"id_worker": 1, "start_date": datetime.utcnow(), "end_date": datetime.utcnow(),
                 "id_job_role": "Шеф-Повар", "surname": "Александров", "name": "Олег", "phone": "+79637259702",
                 "salary": 50000},
                {"id_worker": 2, "start_date": datetime.utcnow(), "end_date": datetime.utcnow(),
                 "id_job_role": "Младший Повар", "surname": "Васильев", "name": "Олег", "phone": "+79637259702",
                 "salary": 30000},
                {"id_worker": 3, "start_date": datetime.utcnow(), "end_date": datetime.utcnow(),
                 "id_job_role": "Младший Повар", "surname": "Иванов", "name": "Михаил", "phone": "+79637259702",
                 "salary": 60000}
            ],
            FoodType: [
                {"type": "Пицца"},
                {"type": "Суши"},
                {"type": "Салаты"},
                {"type": "Напитки"}
            ],
            Food: [
                {"type": "Напитки", "name": "Бурбон", "weight": 200, "unit_of_measurement": "Грамм", "price": 300},
                {"type": "Пицца", "name": "Карбонара", "weight": 800, "unit_of_measurement": "Грамм", "price": 800},
                {"type": "Салаты", "name": "Цезарь", "weight": 400, "unit_of_measurement": "Грамм", "price": 600}
            ],
            OrderDirectory: [
                {"id_worker": 1, "phone_client": "+79389513658", "id_food": 1,
                 "formation_date": datetime.utcnow(), "giving_date": datetime.utcnow(),
                 "status": "Готовится", "num_of_food": 2},
                {"id_worker": 2, "phone_client": "+79637259702", "id_food": 2,
                 "formation_date": datetime.utcnow(), "giving_date": datetime.utcnow(),
                 "status": "Подано", "num_of_food": 1},
                {"id_worker": 3, "phone_client": "+79848718618", "id_food": 3,
                 "formation_date": datetime.utcnow(), "giving_date": datetime.utcnow(),
                 "status": "Готовится", "num_of_food": 4}
            ],
            Ingredient: [
                {"name": "Помидоры", "measurement": "кг", "price": 200, "critical_rate": 5},
                {"name": "Огурцы", "measurement": "кг", "price": 100, "critical_rate": 3},
                {"name": "Мука", "measurement": "кг", "price": 50, "critical_rate": 5}
            ],
            FoodComposition: [
                {"id_food": 1, "id_ingredient": 2, "weight": 300},
                {"id_food": 2, "id_ingredient": 3, "weight": 500},
                {"id_food": 3, "id_ingredient": 1, "weight": 700}
            ],
            Storage: [
                {"name": "Сундук", "address": "Краснодар", "phone": "+79057474162"},
                {"name": "Рундук", "address": "Ростов", "phone": "+79943211287"},
                {"name": "Ларец", "address": "Москва", "phone": "+79279675440"}
            ],
            RequisitionList: [
                {"id_worker": 1, "storage_name": "Сундук", "date": datetime.utcnow(), "status": "В процессе"},
                {"id_worker": 2, "storage_name": "Рундук", "date": datetime.utcnow(), "status": "Выполнено"},
                {"id_worker": 3, "storage_name": "Ларец", "date": datetime.utcnow(), "status": "В процессе"}
            ],
            Requisition: [
                {"id": 1, "id_ingredient": 2, "weight": 2, "quantity": 30},
                {"id": 2, "id_ingredient": 1, "weight": 3, "quantity": 40},
                {"id": 3, "id_ingredient": 3, "weight": 10, "quantity": 50}
            ],
            IngredientStorage: [
                {"id_ingredient": 1, "delivery_date": datetime.utcnow(), "id_request": 1,
                 "valid_until": datetime.utcnow(), "weight": 10, "quantity": 300},
                {"id_ingredient": 2, "delivery_date": datetime.utcnow(), "id_request": 2,
                 "valid_until": datetime.utcnow(), "weight": 1, "quantity": 654},
                {"id_ingredient": 3, "delivery_date": datetime.utcnow(), "id_request": 3,
                 "valid_until": datetime.utcnow(), "weight": 3, "quantity": 700}
            ]
        }

        # Вставка данных
        for table, rows in data.items():
            for row in rows:
                insert_row(table, table(**row), db)

    except Exception as e:
        print(f"Error: {e}")

    finally:
        db.close()


delete_row_extended(FoodComposition, 'contact', 'Глеб', Session())
