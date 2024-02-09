## Поработать с функциями если будет необходимо: 
1) *filter_by()* - для проверки равенства
2) *filter()* - больше фильтров
3) *ilike()* - игнорирование регистра: 
   <p> ses.query(Book).filter(Ingredient.name.ilike('мясо')).first() </p>
4) *between()* для дат:
    <p> start_date = datetime(2009, 1, 1) </p>
    <p> end_date = datetime(2012, 1, 1) </p>
    <p> ses.query(Book).filter(Book.published.between(start_date, end_date)).all() </p>
5) *and_*, *or_*
6) *order_by()*, *desc()*, *asc()*

## Полезные фишки:
1) *limit*
   <p> ses.query(Book).limit(2).all() </p>

## Изменение моделей и использование Alembic для миграции:

      project
      │   alembic.ini
      │   config.py
      │   crud.py
      │   models.py
      │
      └───alembic
          │   env.py
          │   README
          │   script.py.mako
          │
          └───versions