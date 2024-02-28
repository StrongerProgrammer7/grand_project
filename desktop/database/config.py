from my_personal_data import *  # Тут импорт моего личного пароля из файла, которого на Git не будет

DATABASE_URI = f'postgresql://{USERNAME}:{PASSWORD}@{IP}:{PORT}/{DATABASE_NAME}'
