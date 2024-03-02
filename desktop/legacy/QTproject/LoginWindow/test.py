import sys
from PySide6 import QtWidgets
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication, QMainWindow, QLineEdit
from LoginWindow import Ui_Dialog

class LoginWindowApp(QMainWindow):
    def __init__(self, parent=None):
        super(LoginWindowApp, self).__init__(parent)
        self.ui = Ui_Dialog()
        self.ui.setupUi(self)
        self.ui.checkBox.stateChanged.connect(self.change_password_visibility)

    def change_password_visibility(self):
        if self.ui.checkBox.isChecked():
            self.ui.checkBox.setText("Показать пароль")
            self.ui.lineEdit_2.setEchoMode(QLineEdit.Normal)
        else:
            self.ui.checkBox.setText("Скрыть пароль")
            self.ui.lineEdit_2.setEchoMode(QLineEdit.Password)


app = QApplication()
window = LoginWindowApp()
window.show()
sys.exit(app.exec())
