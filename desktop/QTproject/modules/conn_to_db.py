import requests

from desktop.QTproject.main import *
from desktop.my_personal_data import DOMEN


class Conn_to_db(MainWindow):
    api_url = f'https://{DOMEN}/api/'
    api_test = f'https://{DOMEN}/api/test'

    def test_data(self):
        response = requests.post(self.api_test, verify=False)

        if response.status_code == 200:
            print('Ответ от сервера Node.js:', response.json())
        else:
            print('Ошибка при отправке запроса:', response.status_code, response.text)

    def get_model_from_user(self):
        model, ok = QInputDialog.getText(self, 'Введите название модели', 'Модель:')
        if ok:
            return model
        return None

    def get_id_from_user(self):
        id, ok = QInputDialog.getText(self, 'Введите ID элемента', 'ID:')
        if ok:
            return id
        return None

    def get_data(self):
        model = self.get_model_from_user()
        id = self.get_id_from_user()
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.get(url)

            if response.status_code == 200:
                return response.json()
        return None

    def post_data(self, data):
        model = self.get_model_from_user()
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.post(url, json=data)

            if response.status_code == 200:
                return response.json()
        return None

    def put_data(self, data):
        model = self.get_model_from_user()
        id = self.get_id_from_user()
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.put(url, json=data)

            if response.status_code == 200:
                return response.json()
        return None

    def delete_data(self):
        model = self.get_model_from_user()
        id = self.get_id_from_user()
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.delete(url)

            if response.status_code == 200:
                return response.json()
        return None
