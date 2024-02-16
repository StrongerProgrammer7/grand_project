import requests
import httpx
import asyncio

import settings


# ----------------- Node ----------------- #
# Клиентский код для отправки запросов
async def send_request(url, method='GET', json_payload=None):
    async with httpx.AsyncClient() as client:
        if method == 'GET':
            response = await client.get(url)
        elif method == 'POST':
            response = await client.post(url, json=json_payload)
        elif method == 'PUT':
            response = await client.put(url, json=json_payload)
        elif method == 'DELETE':
            response = await client.delete(url)
        else:
            raise ValueError(f"Unsupported HTTP method: {method}")

        return response


# Пример как я хочу получать информацию из api
async def test_request():
    # Создать базу данных
    response = await send_request(f'{settings.SERVER_URL}/create_database/', method='POST')
    print(response.json())

    # Выбрать строку по ID (пример для модели IngredientStorage)
    response = await send_request(f'{settings.SERVER_URL}/select_row/IngredientStorage/1', method='GET')
    print(response.json())

    # Вставить новую строку (пример для модели Ingredient)
    new_ingredient = {"id": 1, "name": "NewIngredient", "measurement": "kg", "price": 10.0, "critical_rate": 5}
    response = await send_request(f'{settings.SERVER_URL}/insert_row/Ingredient', method='POST',
                                  json_payload=new_ingredient)
    print(response.json())


def test_conn():
    # Отправка GET-запроса
    response = requests.get(settings.TEST_URL)

    # Проверка успешности запроса
    if response.status_code == 200:
        # Получение данных в формате JSON
        data = response.json()
        message = data.get("message")
        print(f"Received message: {message}")
    else:
        print(f"Error: {response.status_code}")


test_conn()
# asyncio.run(test_request())
