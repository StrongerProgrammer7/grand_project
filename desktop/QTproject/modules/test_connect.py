import sys

import requests
from PySide6.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QLabel, QInputDialog
import urllib3

# urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.layout = QVBoxLayout(self)

        self.button_post = QPushButton('Отправить данные', self)
        self.layout.addWidget(self.button_post)

        self.button_post.clicked.connect(self.test_data)

        self.base_url = 'https://grandproject.k-lab.su/api/test'

    def test_data(self):
        response = requests.post(self.base_url, verify=False)

        if response.status_code == 200:
            print('Ответ от сервера Node.js:', response.json())
        else:
            print('Ошибка при отправке запроса:', response.status_code, response.text)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
