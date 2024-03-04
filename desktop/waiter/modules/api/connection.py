import json
import requests
from secret_file import *


class ApiConnect:
    api_url = f'https://{DOMEN}/api/'

    def get(self, model: int, id: int):
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.get(url, verify=False)

            if response.status_code == 200:
                return response.json()
        return None

    def post_data(self, model: int, data: json):
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.post(url, json=data, verify=False)

            if response.status_code == 200:
                return response.json()
        return None

    def put_data(self, model: str, id: int, data: json):
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.put(url, json=data, verify=False)

            if response.status_code == 200:
                return response.json()
        return None

    def delete_data(self, model: str, id: int):
        if model and id:
            url = f'{self.api_url}/{model}/{id}'
            response = requests.delete(url, verify=False)

            if response.status_code == 200:
                return response.json()
        return None
