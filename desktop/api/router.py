from fastapi import APIRouter, Depends
from crud import *

router = APIRouter(
    # prefix='/db',
    tags=['Postgres'],
    responses={404: {"description": "Not found"}}
)


# ////////////////////////////////////////////////// Роутеры ////////////////////////////////////////////////// #
@router.post("/recreate_database/")
def recreate_database_route():
    return recreate_database()


@router.post("/create_database/")
def create_database_route():
    return create_database()


@router.get("/select_row/{model_name}/{item_id}")
def select_row_route(model_name: str, item_id: int, db: Session = Depends(get_db)):
    """
    Выбор строки из базы данных по ID для указанной модели.
    """
    model_class = globals()[model_name]
    return select_row(model_class, item_id, db)


@router.get("/select_table/{model_name}")
def select_table_route(model_name: str, db: Session = Depends(get_db)):
    """
    Выбор всех строк из таблицы базы данных для указанной модели.
    """
    model_class = globals()[model_name]
    return select_table(model_class, db)


@router.post("/insert_row/{model_name}")
def insert_row_route(model_name: str, item: BaseModel, db: Session = Depends(get_db)):
    """
    Вставка новой строки в базу данных для указанной модели.
    """
    model_class = globals()[model_name]
    return insert_row(model_class, item, db)


@router.post("/insert_table/{model_name}")
def insert_table_route(model_name: str, items: list, db: Session = Depends(get_db)):
    """
    Вставка нескольких строк в базу данных для указанной модели.
    """
    model_class = globals()[model_name]
    return insert_table(model_class, items, db)


@router.delete("/delete_row/{model_name}/{item_id}")
def delete_row_route(model_name: str, item_id: int, db: Session = Depends(get_db)):
    """
    Удаление строки из базы данных по ID для указанной модели.
    """
    model_class = globals()[model_name]
    return delete_row(model_class, item_id, db)


@router.put("/update_row/{model_name}/{item_id}")
def update_row_route(model_name: str, item_id: int, updated_item: BaseModel, db: Session = Depends(get_db)):
    """
    Изменение строки из базы данных по ID для указанной модели.
    """
    model_class = globals()[model_name]
    return update_row(model_class, item_id, updated_item, db)
