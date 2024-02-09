from abc import ABC, abstractmethod
import os
import yaml
import json

JSON_FILE_PATH = YAML_FILE_PATH = 'desktop/database/file_manager/data'


class Strategy(ABC):
    @staticmethod
    @abstractmethod
    def read():
        pass

    @staticmethod
    @abstractmethod
    def write(data):
        pass


class JSON_work(Strategy):
    @staticmethod
    def read():
        print(os.path.exists(f"{JSON_FILE_PATH}.json"))
        if os.path.exists(f"{JSON_FILE_PATH}.json"):
            with open(f"{JSON_FILE_PATH}.json", 'r', encoding='UTF8') as json_file:
                return json.load(json_file)
        else:
            print(f'Ошибка чтения {JSON_FILE_PATH}.json')
            return None

    @staticmethod
    def write(data):
        with open(f"{JSON_FILE_PATH}.json", 'w', encoding='UTF8') as json_file:
            json.dump(data, json_file)


class YAML_work(Strategy):
    @staticmethod
    def read():
        if os.path.exists(f"{YAML_FILE_PATH}.yaml"):
            print('True')
            with open(f"{YAML_FILE_PATH}.yaml", 'r', encoding='UTF8') as yaml_file:
                return yaml.safe_load(yaml_file)
        else:
            print(f'Ошибка чтения {YAML_FILE_PATH}.yaml')
            return None

    @staticmethod
    def write(data):
        with open(f"{YAML_FILE_PATH}.yaml", 'w', encoding='UTF8') as yaml_file:
            yaml.dump(data, yaml_file)
