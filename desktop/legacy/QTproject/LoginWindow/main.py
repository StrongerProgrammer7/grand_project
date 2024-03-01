import sys
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
            self.ui.lineEdit_2.setEchoMode(QLineEdit.Normal)
        else:
            self.ui.lineEdit_2.setEchoMode(QLineEdit.Password)


if __name__ == "__main__":
    app = QApplication()
    window = LoginWindowApp()
    window.show()
    sys.exit(app.exec())
