# ///////////////////////////////////////////////////////////////
#
# BY: WANDERSON M.PIMENTA
# PROJECT MADE WITH: Qt Designer and PySide6
# V: 1.0.0
#
# This project can be used freely for all uses, as long as they maintain the
# respective credits only in the Python scripts, any information in the visual
# interface (GUI) can be modified without any implication.
#
# There are limitations on Qt licenses if you want to use your products
# commercially, I recommend reading them on the official website:
# https://doc.qt.io/qtforpython/licenses.html
#
# ///////////////////////////////////////////////////////////////

import sys
import os
import platform

from PySide6.QtWidgets import QMainWindow
from PySide6 import QtWidgets
from modules.addview import Ui_Dialog
from modules.addview2 import Ui_Dialog2

# IMPORT / GUI AND MODULES AND WIDGETS
# ///////////////////////////////////////////////////////////////
from modules import *
from widgets import *

os.environ["QT_FONT_DPI"] = "96"  # FIX Problem for High DPI and Scale above 100%

# SET AS GLOBAL WIDGETS
# ///////////////////////////////////////////////////////////////
widgets = None


class MainWindow(QMainWindow):
    def __init__(self):
        QMainWindow.__init__(self)

        # SET AS GLOBAL WIDGETS
        # ///////////////////////////////////////////////////////////////
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        global widgets
        widgets = self.ui



        # USE CUSTOM TITLE BAR | USE AS "False" FOR MAC OR LINUX
        # ///////////////////////////////////////////////////////////////
        Settings.ENABLE_CUSTOM_TITLE_BAR = True

        # APP NAME
        # ///////////////////////////////////////////////////////////////
        title = "SOLIDSIGN - для официантов"
        description = "SOLIDSIGN APP - Theme with colors based on Dracula for Python."
        # APPLY TEXTS
        #self.setWindowTitle(title)
        #widgets.titleRightInfo.setText(description)

        # TOGGLE MENU
        # ///////////////////////////////////////////////////////////////
        # widgets.toggleButton.clicked.connect(lambda: UIFunctions.toggleMenu(self, True))

        # SET UI DEFINITIONS
        # ///////////////////////////////////////////////////////////////
        UIFunctions.uiDefinitions(self)

        # QTableWidget PARAMETERS
        # ///////////////////////////////////////////////////////////////
        widgets.tableWidget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        # BUTTONS CLICK
        # ///////////////////////////////////////////////////////////////

        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)
        widgets.btn_new.clicked.connect(self.buttonClick)

        # widgets.btn_save.clicked.connect(self.buttonClick)

        # EXTRA LEFT BOX
        # def openCloseLeftBox():
        # UIFunctions.toggleLeftBox(self, True)

        # widgets.toggleLeftBox.clicked.connect(openCloseLeftBox)
        # widgets.extraCloseColumnBtn.clicked.connect(openCloseLeftBox)

        # EXTRA RIGHT BOX
        #def openCloseRightBox():
        #    UIFunctions.toggleRightBox(self, True)

        #widgets.settingsTopBtn.clicked.connect(openCloseRightBox)

        # SHOW APP
        # ///////////////////////////////////////////////////////////////
        self.show()
        # SET CUSTOM THEME
        # ///////////////////////////////////////////////////////////////
        self.themeFile = "themes/py_dracula_dark.qss"
        self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")
        widgets.label.setStyleSheet("image: url(images/images/logo.png)")
        #widgets.toggleLeftBox.setStyleSheet("background-image: url(images/icons/moon.png)")

        UIFunctions.theme(self, self.themeFile, True)
        widgets.settingsTopBtn.clicked.connect(lambda: UIFunctions.toggle_theme(self))

        # DATETIME
        self.timer = QTimer(self)
        self.timer.timeout.connect(lambda: UIFunctions.update_time(self))
        self.timer.start(0)

        # DIALOG WINDOWS
        self.ui_dialog = Ui_Dialog()
        self.ui_dialog.setupUi(self)
        self.new_window = QtWidgets.QDialog()
        self.ui_dialog.setupUi(self.new_window)
        self.new_window.setFixedSize(self.new_window.size())

        self.ui_dialog2 = Ui_Dialog2()
        self.ui_dialog2.setupUi(self)
        self.new_window2 = QtWidgets.QDialog()
        self.ui_dialog2.setupUi(self.new_window2)
        self.new_window2.setFixedSize(self.new_window2.size())

        # 1 ВКЛАДКА КНОПКИ
        widgets.addrow_btn.clicked.connect(lambda: UIFunctions.generate_new_row(self))
        widgets.delrow_btn.clicked.connect(lambda: UIFunctions.delete_row(self))
        widgets.clearbtn.clicked.connect(lambda: UIFunctions.clear_table(self))
        # widgets.utvrbtn.clicked.connect() Здесь могла быть ваша функция:)

        # 2 ВКЛАДКА
        widgets.pushButton_3.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget))
        widgets.pushButton_2.clicked.connect(lambda: UIFunctions.open_new_window(self))

        # 3 ВКЛАДКА
        widgets.pushButton_9.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget_3))
        widgets.pushButton_8.clicked.connect(lambda: UIFunctions.open_new_window2(self))

        self.ui_dialog.addtransbtn.clicked.connect(self.update_second_table)
        self.ui_dialog2.addtransbtn.clicked.connect(self.update_third_table)

        tab1_column_widths = [10, 150, 120, 200, 200, 100]
        UIFunctions.set_column_widths(self, widgets.tableWidget, tab1_column_widths)

        tab2_column_widths = [30, 150, 150, 200, 200, 250, 200, 200]
        UIFunctions.set_column_widths(self, widgets.tableWidget_3, tab2_column_widths)

        # SET HACKS
        # AppFunctions.setThemeHack(self)

        # SET HOME PAGE AND SELECT MENU
        # ///////////////////////////////////////////////////////////////
        widgets.stackedWidget.setCurrentWidget(widgets.home)
        widgets.btn_home.setStyleSheet(UIFunctions.selectMenu(widgets.btn_home.styleSheet()))

    # BUTTONS CLICK
    # Post here your functions for clicked buttons
    # ///////////////////////////////////////////////////////////////
    def buttonClick(self):
        # GET BUTTON CLICKED
        btn = self.sender()
        btnName = btn.objectName()

        # SHOW HOME PAGE
        if btnName == "btn_home":
            widgets.stackedWidget.setCurrentWidget(widgets.home)
            UIFunctions.resetStyle(self, btnName)
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet()))

        # SHOW WIDGETS PAGE
        if btnName == "btn_widgets":
            widgets.stackedWidget.setCurrentWidget(widgets.widgets)
            UIFunctions.resetStyle(self, btnName)
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet()))

        # SHOW NEW PAGE
        if btnName == "btn_new":
            widgets.stackedWidget.setCurrentWidget(widgets.new_page)  # SET PAGE
            UIFunctions.resetStyle(self, btnName)  # RESET ANOTHERS BUTTONS SELECTED
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet()))  # SELECT MENU

        if btnName == "btn_save":
            print("Save BTN clicked!")

        # PRINT BTN NAME
        print(f'Button "{btnName}" pressed!')

    # RESIZE EVENTS
    # ///////////////////////////////////////////////////////////////
    def resizeEvent(self, event):
        # Update Size Grips
        UIFunctions.resize_grips(self)

    # MOUSE CLICK EVENTS
    # ///////////////////////////////////////////////////////////////
    def mousePressEvent(self, event):
        # SET DRAG POS WINDOW
        self.dragPos = event.globalPos()

        # PRINT MOUSE EVENTS
        if event.buttons() == Qt.LeftButton:
            print('Mouse click: LEFT CLICK')
        if event.buttons() == Qt.RightButton:
            print('Mouse click: RIGHT CLICK')

    def open_new_window(self):
        self.new_window.exec()

    def open_new_window2(self):
        self.new_window2.exec()

    def update_second_table(self):
        time1 = self.ui_dialog.timeEdit.text()
        date = self.ui_dialog.dateEdit.text()
        combBox = self.ui_dialog.comboBox.currentText()
        line = self.ui_dialog.lineEdit.text()
        time2 = self.ui_dialog.timeEdit_2.text()

        # Создаем диалоговое окно для подтверждения
        confirm_dialog = QMessageBox()
        confirm_dialog.setIcon(QMessageBox.Question)
        confirm_dialog.setText("Вы уверены, что хотите внести изменения в таблицу 'Заказы'?")
        confirm_dialog.setWindowTitle("Подтверждение")
        confirm_dialog.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
        confirm_dialog.setDefaultButton(QMessageBox.No)

        # Показываем диалоговое окно и ждем ответа пользователя
        response = confirm_dialog.exec()

        if response == QMessageBox.Yes:
            # Получаем индекс выбранной строки
            selected_row = self.ui.tableWidget.currentRow()

            if selected_row >= 0:  # Проверяем, что строка действительно выбрана
                # Устанавливаем значения в каждом столбце выбранной строки
                self.ui.tableWidget.setItem(selected_row, 0,
                                            QTableWidgetItem(str(selected_row + 1)))  # автоинкрементный id
                self.ui.tableWidget.setItem(selected_row, 1, QTableWidgetItem(time1))
                self.ui.tableWidget.setItem(selected_row, 2, QTableWidgetItem(date))
                self.ui.tableWidget.setItem(selected_row, 3, QTableWidgetItem(combBox))
                self.ui.tableWidget.setItem(selected_row, 4, QTableWidgetItem(line))
                self.ui.tableWidget.setItem(selected_row, 5, QTableWidgetItem(time2))

            self.new_window.close()
        else:
            # Если пользователь отменил действие, ничего не делаем
            pass

    def update_third_table(self):
        combBox = self.ui_dialog2.comboBox.currentText()
        time = self.ui_dialog2.timeEdit.text()
        line = self.ui_dialog2.lineEdit.text()
        line2 = self.ui_dialog2.lineEdit_2.text()

        # Создаем диалоговое окно для подтверждения
        confirm_dialog = QMessageBox()
        confirm_dialog.setIcon(QMessageBox.Question)
        confirm_dialog.setText("Вы уверены, что хотите внести изменения в таблицу 'Заказы'?")
        confirm_dialog.setWindowTitle("Подтверждение")
        confirm_dialog.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
        confirm_dialog.setDefaultButton(QMessageBox.No)

        # Показываем диалоговое окно и ждем ответа пользователя
        response = confirm_dialog.exec()

        if response == QMessageBox.Yes:
            # Получаем индекс выбранной строки
            selected_row = self.ui.tableWidget_3.currentRow()

            if selected_row >= 0:  # Проверяем, что строка действительно выбрана
                # Устанавливаем значения в каждом столбце выбранной строки
                self.ui.tableWidget_3.setItem(selected_row, 0,
                                            QTableWidgetItem(str(selected_row + 1)))  # автоинкрементный id
                self.ui.tableWidget_3.setItem(selected_row, 1, QTableWidgetItem(combBox))
                self.ui.tableWidget_3.setItem(selected_row, 2, QTableWidgetItem(time))
                self.ui.tableWidget_3.setItem(selected_row, 3, QTableWidgetItem(line))
                self.ui.tableWidget_3.setItem(selected_row, 4, QTableWidgetItem(line2))

            self.new_window2.close()
        else:
            # Если пользователь отменил действие, ничего не делаем
            pass


if __name__ == "__main__":
    app = QApplication(sys.argv)
    #app.setWindowIcon(QIcon("icon.ico"))
    window = MainWindow()
    sys.exit(app.exec())
