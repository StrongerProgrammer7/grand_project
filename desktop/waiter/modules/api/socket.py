# waiter

import sys
from PySide6.QtWidgets import QApplication, QWidget, QPushButton
import socketio
import requests


# Функция для отправки сообщения на сервер
def send_message():
    # Создаем JSON-сообщение
    message = message = {
        "worker_id": 1,
        "food_ids": [
            1,
            2
        ],
        "quantities": [1, 2],
        "formation_date": "2024-03-04, 11:31:11",
        "givig_date": "2024-03-04, 11:31:11",
        "status": "In Progress",
        "path": "/api/add_client_order",
        "method": "POST",
        "send": {
            "name": "povar",
            "id": 2
        }
    }
    # Отправляем сообщение через сокет
    sio.emit('message', message)
    print("Message sent:", message)


# Функция для обработки полученных сообщений от сервера
def on_message(data):
    print("Message received:", data)


# Создание экземпляра клиента Socket.IO с отключенной проверкой SSL
sio = socketio.Client(ssl_verify=False)

# Подписка на событие 'message'
sio.on('message', on_message)

url = 'https://grandproject.k-lab.su/api/signIn'  # URL для входа в систему
data = {'login': 'login', 'password': 'lovemom'}  # Данные для входа в систему

response = requests.post(url, data=data, verify=False)

if response.status_code == 201:
    print('Запрос выполнен успешно')
    response_data = response.json()  # Получение данных ответа
    print(response_data)

    # Извлечение токена из ответа
    token = response_data['data']['token']
    print(f"Токен: {token}")

    # URL для подключения к Socket.IO. Замените на актуальный URL
    # socket_io_url = "wss://grandproject.k-lab.su:444"
    socket_io_url = "ws://grandproject.k-lab.su:80"

    # Подключение к серверу Socket.IO с использованием токена
    sio.connect(socket_io_url, auth={"token": token, "name": "waiter", "id": 1})

else:
    print('Ошибка при выполнении запроса:', response.status_code)

