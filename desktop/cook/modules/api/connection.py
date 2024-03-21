import json
import os
import urllib3
import requests
from .secret_file import DOMEN

urllib3.disable_warnings()


class ApiConnect:
    api_url = f'https://{DOMEN}/api'

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


