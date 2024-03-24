import json
import os

import urllib3
import requests
import socketio
from .secret_file import DOMEN

import bcrypt

urllib3.disable_warnings()


class ApiConnect:


    _instance = None # Атрибут для хранения экземпляра класса

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super().__new__(cls)
        return cls._instance


    def __init__(self, ssl_cert):
        # Проверяем, инициализирован ли экземпляр
        if not hasattr(self, 'api_url'):
            self.api_url = f'https://{DOMEN}/api'
            self.sio = socketio.Client(ssl_verify=ssl_cert)
            self.sio.on('connect', self.connect)
            self.sio.on('disconnect', self.disconnect)
            self.sio.on('message', self.on_message)

    def connect_to_server(self):
        # Подключаемся к серверу
        self.sio.connect(self.api_url, auth={"token": "0x0324234", "name": "waiter", "idWaiter": 1})

    def connect(self):
        print("Connected to the server")
        self.send_initial_data()

    def disconnect(self):
        print("Disconnected from the server")

    def on_message(self, data):
        print('Message from server:', data)

    def send_initial_data(self):
        auth = {"token": "0x0324234", "name": "waiter", "idWaiter": 1}
        self.sio.emit('auth', auth)

    # WEBSOCKET MOMENT
    def send_message(self, data):
        # Создаем JSON-сообщение
        message = {"text": "Сообщение отправлено на сервер"}
        # Отправляем сообщение через сокет
        self.sio.emit('message', data)
        print("Message sent:", message)

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

    def authentification (self, endpoint, login, password):
        url = f'{self.api_url}/{endpoint}'
        salt = bcrypt.gensalt(10)
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
        data = {
            "login": login,
            "password": hashed_password
        }
        response = requests.post(url, json=data, verify=False)


        if 200 <= response.status_code < 300:
            return True
