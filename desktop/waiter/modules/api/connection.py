import json
import os
import urllib3
import requests
from .secret_file import DOMEN

urllib3.disable_warnings()


class ApiConnect:
    api_url = f'https://{DOMEN}/api'

    def get_data(self, model: str):
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.get(url, verify=False)
            if response.status_code == 201:
                return response.json()
        return None

    def post_data(self, model: str, data: json):
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.post(url, json=data, verify=False)

            if response.status_code == 201:
                return response.json()
        return None

    def put_data(self, model: str):
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.put(url, verify=False)

            if response.status_code == 201:
                return response.json()
        return None

    def delete_data(self, model: str):
        if model:
            url = f'{self.api_url}/{model}'
            response = requests.delete(url, verify=False)

            if response.status_code == 201:
                return response.json()
        return None

    def test_get(self, model: str):
        if model:
            file_path = os.path.join("jsons", f"{model}.json")

            if os.path.exists(file_path):
                with open(file_path, 'r') as file:
                    json_data = json.load(file)
                return json_data
        return None



