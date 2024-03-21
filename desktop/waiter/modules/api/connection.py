import json
import os
import urllib3
import requests
import socketio
from .secret_file import DOMEN

urllib3.disable_warnings()


class ApiConnect:
    api_url = f'https://{DOMEN}/api'
    # Создаем сокет-клиент и подключаемся
    sio = socketio.Client()

    try:
        r = requests.get(f'{api_url}')
        r.raise_for_status()
    except (requests.exceptions.ConnectionError, requests.exceptions.Timeout):
        print("Сервер не запущен")
    except requests.exceptions.HTTPError:
        print("4xx, 5xx")
    else:
        sio.connect('http://localhost:8080')

    def get_data(self, endpoint: str):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            response = requests.get(url, verify=False)

            if response.status_code == 201:
                print(f'get_data | {endpoint} | ', response.status_code)
                return response.json()
        print('None')
        return None

    def post_data(self, endpoint: str, data: json):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            response = requests.post(url, json=data, verify=False)

            print(f'post_data | {endpoint} | ', response.status_code)
            if response.status_code == 201:
                return response.json()
        return None

    def put_data(self, endpoint: str):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            response = requests.put(url, verify=False)

            if response.status_code == 201:
                return response.json()
        return None

    def delete_data(self, endpoint: str):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            response = requests.delete(url, verify=False)

            if response.status_code == 201:
                return response.json()
        return None

    # WEBSOCKET MOMENT
    def send_message(self, data):
        # Создаем JSON-сообщение
        message = {"text": "Сообщение отправлено на сервер"}
        # Отправляем сообщение через сокет
        self.sio.emit('message', data)
        print("Message sent:", message)

    @sio.event
    def connect(self):
        print("Connected to the server")

    @sio.event
    def disconnect(self):
        print("Disconnected from the server")

    @sio.on('message')
    def on_message(self, data):
        print('Message from server:', data)
