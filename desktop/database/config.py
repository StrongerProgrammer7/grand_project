from my_personal_data import PASSWORD, IP  # Тут импорт моего личного пароля из файла, которого на Git не будет

# Схема: "postgresql+psycopg2://<USERNAME>:<PASSWORD>@<IP_ADDRESS>:<PORT>/<DATABASE_NAME>"
DATABASE_URI = f'postgresql://postgres:{PASSWORD}@localhost:5432/test'

# При подключенни не к localhost:
# DATABASE_URL = f'postgresql+psycopg2://postgres:{PASSWORD}@{IP}:5432/IngredientStorage?sslmode=require'
