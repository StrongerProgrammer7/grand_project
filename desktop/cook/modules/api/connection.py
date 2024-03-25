import json
import os

import bcrypt
import urllib3
import requests
import socketio
from requests import HTTPError

from .secret_file import DOMEN

urllib3.disable_warnings()


class ApiConnect:
    _instance = None  # Атрибут для хранения экземпляра класса

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self, ssl_cert):
        # Проверяем, инициализирован ли экземпляр
        if not hasattr(self, 'api_url'):
            self.api_url = f'https://{DOMEN}/api'
            self.socket_io_url = f"ws://{DOMEN}:80"
            self.ssl_cert_path = './fullchain.pem'
            self.sio = socketio.Client(ssl_verify=ssl_cert)
            self.sio.on('connect', self.connect)
            self.sio.on('disconnect', self.disconnect)
            self.sio.on('message', self.on_message)

    # def connect_to_server(self):
    #     # Подключаемся к серверу
    #     self.sio.connect(f'wss://{DOMEN}', auth={
    #         "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
    #                  ".eyJpZCI6OSwibG9naW4iOiJsb2dpbiIsImlhdCI6MTcxMTMxNTI2MiwiZXhwIjoxNzExMzc1MjYyfQ"
    #                  ".iQC054bjNgi5sJnlp1LML9i9L-Q-A7MRqC44VUpgep0",
    #         "name": "povar", "id": 2})

    def connect(self):
        print("Connected to the server")
        # self.send_initial_data()

    def disconnect(self):
        print("Disconnected from the server")

    def on_message(self, data):
        print('Message from server:', data)


    # def send_initial_data(self):
    #     auth = {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
    #                      ".eyJpZCI6OSwibG9naW4iOiJsb2dpbiIsImlhdCI6MTcxMTMxNTI2MiwiZXhwIjoxNzExMzc1MjYyfQ"
    #                      ".iQC054bjNgi5sJnlp1LML9i9L-Q-A7MRqC44VUpgep0", "name": "cook", "id": 1}
    #     self.sio.emit('auth', auth)

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
            try:
                response = requests.get(url, verify=self.ssl_cert_path)
                response.raise_for_status()  # Вызовет исключение HTTPError для кодов статуса 4xx и 5xx
                if response.status_code == 201:
                    print(f'get_data | {endpoint} | ', response.status_code)
                    return response.json()
            except HTTPError as http_err:
                print(f'HTTP error occurred: {http_err}')
                print(f'Response content: {response.content}')  # Вывод данных ответа
            except Exception as err:
                print(f'Other error occurred: {err}')
        print('None')
        return None

    def post_data(self, endpoint: str, data: json):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            try:
                response = requests.post(url, json=data, verify=self.ssl_cert_path)
                response.raise_for_status()  # Вызовет исключение HTTPError для кодов статуса 4xx и 5xx
                if response.status_code == 201:
                    print(f'post_data | {endpoint} | ', response.status_code)
                    return response.json()
            except HTTPError as http_err:
                print(f'HTTP error occurred: {http_err}')
                print(f'Response content: {response.content}')  # Вывод данных ответа
            except Exception as err:
                print(f'Other error occurred: {err}')
        print('None')
        return None

    def put_data(self, endpoint: str):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            try:
                response = requests.post(url, verify=self.ssl_cert_path)
                response.raise_for_status()  # Вызовет исключение HTTPError для кодов статуса 4xx и 5xx
                if response.status_code == 201:
                    print(f'put_data | {endpoint} | ', response.status_code)
                    return response.json()
            except HTTPError as http_err:
                print(f'HTTP error occurred: {http_err}')
                print(f'Response content: {response.content}')  # Вывод данных ответа
            except Exception as err:
                print(f'Other error occurred: {err}')
        print('None')
        return None

    def delete_data(self, endpoint: str):
        if endpoint:
            url = f'{self.api_url}/{endpoint}'
            try:
                response = requests.delete(url, verify=self.ssl_cert_path)
                response.raise_for_status()  # Вызовет исключение HTTPError для кодов статуса 4xx и 5xx
                if response.status_code == 201:
                    print(f'del_data | {endpoint} | ', response.status_code)
                    return response.json()
            except HTTPError as http_err:
                print(f'HTTP error occurred: {http_err}')
                print(f'Response content: {response.content}')  # Вывод данных ответа
            except Exception as err:
                print(f'Other error occurred: {err}')
        print('None')
        return None

    def auth(self, data):
        url = f'{self.api_url}/signIn'

        response = requests.post(url, data=data, verify=self.ssl_cert_path)

        if response.status_code == 201:
            response_data = response.json()  # Если сервер возвращает JSON, можно получить данные в виде словаря
            print(f'post_data | singIn | ', response.status_code)

            # Извлечение токена из ответа
            token = response_data['data']['token']
            print(f"Токен: {token}")

            self.sio.connect(self.socket_io_url, auth={"token": token, "name": "povar", "id": 2})
            return True
        else:
            print('Ошибка при выполнении запроса:', response.status_code)
        return False
