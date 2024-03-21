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
from modules.LoginWindow import Ui_Dialog3

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

        self.api = ApiConnect()

        # USE CUSTOM TITLE BAR | USE AS "False" FOR MAC OR LINUX
        Settings.ENABLE_CUSTOM_TITLE_BAR = True

        # TOGGLE MENU
        widgets.toggleButton.clicked.connect(lambda: UIFunctions.toggleMenu(self, True))

        # SET UI DEFINITIONS
        UIFunctions.uiDefinitions(self)

        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)
        widgets.btn_new.clicked.connect(self.buttonClick)



        # Открываем файл ordernum и читаем из него текст
        with open('ordernum', 'r') as file:
            num = file.read()
        current_text = widgets.label_2.text()
        combined_text = f"{current_text} {num}"
        widgets.label_2.setText(combined_text)

        # SET CUSTOM THEME
        # ///////////////////////////////////////////////////////////////
        self.themeFile = "themes/py_dracula_dark.qss"
        self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")
        UIFunctions.theme(self, self.themeFile, True)

        widgets.label.setStyleSheet("image: url(images/images/logo.png)")
        #widgets.toggleLeftBox.setStyleSheet("background-image: url(images/icons/moon.png)")

        widgets.settingsTopBtn.clicked.connect(lambda: UIFunctions.toggle_theme(self))

        # DATETIME
        self.timer = QTimer(self)
        self.timer.timeout.connect(lambda: UIFunctions.update_time(self))
        self.timer.start(0)

        self.new_window = QtWidgets.QDialog()
        self.ui_dialog = Ui_Dialog()
        self.ui_dialog.setupUi(self.new_window)
        self.new_window.setFixedSize(self.new_window.size())

        self.new_window2 = QtWidgets.QDialog()
        self.ui_dialog2 = Ui_Dialog2()
        self.ui_dialog2.setupUi(self.new_window2)
        self.new_window2.setFixedSize(self.new_window2.size())

        self.new_window3 = QtWidgets.QDialog()
        self.ui_dialog3 = Ui_Dialog3()
        self.ui_dialog3.setupUi(self.new_window3)
        self.new_window3.setFixedSize(self.new_window3.size())

        self.ui_dialog3.checkBox.stateChanged.connect(self.change_password_visibility)
        self.ui_dialog3.pushButton.clicked.connect(self.login)

        widgets.addrow_btn.clicked.connect(lambda: UIFunctions.generate_new_row(self))
        widgets.delrow_btn.clicked.connect(lambda: UIFunctions.delete_row(self))
        widgets.clearbtn.clicked.connect(lambda: UIFunctions.clear_table(self))
        widgets.utvrbtn.clicked.connect(lambda: UIFunctions.commit(self, widgets.tableWidget_2))  # Здесь могла быть ваша функция:)

        # 2 ВКЛАДКА
        widgets.pushButton_3.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget))
        widgets.pushButton_2.clicked.connect(self.open_new_window)

        # 3 ВКЛАДКА
        widgets.pushButton_9.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget_3))
        widgets.pushButton_8.clicked.connect(self.open_new_window2)

        self.ui_dialog.addtransbtn.clicked.connect(self.update_second_table)
        self.ui_dialog2.addtransbtn.clicked.connect(self.update_third_table)

        tab1_column_widths = [80, 200, 200, 200, 200, 200]
        UIFunctions.set_column_widths(self, widgets.tableWidget, tab1_column_widths)



        tab2_column_widths = [80, 200, 200, 200, 200, 200, 200, 200]
        UIFunctions.set_column_widths(self, widgets.tableWidget_3, tab2_column_widths)

        self.fill_table_widget(self.ui.tableWidget)

        # Сортировка таблиц
        self.column_sort_order = {}
        self.connect_sorting_function(widgets.tableWidget)
        self.connect_sorting_function(widgets.tableWidget_2)
        self.connect_sorting_function(widgets.tableWidget_3)



        # SET HOME PAGE AND SELECT MENU
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
        selected_row = self.ui.tableWidget.currentRow()
        if selected_row >= 0:  # Проверяем, что строка действительно выбрана
            # Получаем содержимое каждой ячейки выбранной строки
            line = self.ui.tableWidget.item(selected_row, 1).text()
            datetime1 = self.ui.tableWidget.item(selected_row, 2).text()
            datetime2 = self.ui.tableWidget.item(selected_row, 3).text()
            line2 = self.ui.tableWidget.item(selected_row, 4).text()
            combBox = self.ui.tableWidget.item(selected_row, 5).text()

            # Отображаем данные выбранной строки в диалоговом окне перед его открытием
            self.ui_dialog.lineEdit.setText(line)
            self.ui_dialog.dateTimeEdit.setDateTime(QDateTime.fromString(datetime1, "yyyy-MM-dd hh:mm:ss"))
            self.ui_dialog.dateTimeEdit_2.setDateTime(QDateTime.fromString(datetime2, "yyyy-MM-dd hh:mm:ss"))
            self.ui_dialog.lineEdit_2.setText(line2)
            self.ui_dialog.comboBox.setCurrentText(combBox)
        self.new_window.show()

    def open_new_window2(self):
        selected_row = self.ui.tableWidget_3.currentRow()
        if selected_row >= 0:  # Проверяем, что строка действительно выбрана
            # Получаем содержимое каждой ячейки выбранной строки
            line = self.ui.tableWidget_3.item(selected_row, 1).text()
            datetime1 = self.ui.tableWidget_3.item(selected_row, 2).text()
            datetime2 = self.ui.tableWidget_3.item(selected_row, 3).text()
            line2 = self.ui.tableWidget_3.item(selected_row, 4).text()
            line3 = self.ui.tableWidget_3.item(selected_row, 5).text()
            line4 = self.ui.tableWidget_3.item(selected_row, 6).text()

            # Отображаем данные выбранной строки в диалоговом окне перед его открытием
            self.ui_dialog2.lineEdit.setText(line)
            self.ui_dialog2.dateTimeEdit.setDateTime(QDateTime.fromString(datetime1, "yyyy-MM-dd hh:mm:ss"))
            self.ui_dialog2.dateTimeEdit_2.setDateTime(QDateTime.fromString(datetime2, "yyyy-MM-dd hh:mm:ss"))
            self.ui_dialog2.lineEdit_2.setText(line2)
            self.ui_dialog2.lineEdit_3.setText(line3)
            self.ui_dialog2.lineEdit_4.setText(line4)

        self.new_window2.show()

    def login(self):
        username = self.ui_dialog3.lineEdit.text()
        password = self.ui_dialog3.lineEdit_2.text()
        if username == "" and password == "":
            self.new_window3.close()
            self.show()
        else:
            msg = QMessageBox()
            msg.setWindowTitle("Ошибка входа")
            msg.setText("Логин или пароль неверны.")
            msg.setIcon(QMessageBox.Critical)
            msg.exec()

    def change_password_visibility(self):
        if self.ui_dialog3.checkBox.isChecked():
            self.ui_dialog3.lineEdit_2.setEchoMode(QLineEdit.Normal)
        else:
            self.ui_dialog3.lineEdit_2.setEchoMode(QLineEdit.Password)

    def connect_sorting_function(self, table_widget):
        table_widget.horizontalHeader().sectionClicked.connect(
            lambda index: self.sort_table_column(table_widget, index))

    def sort_table_column(self, table, column_index):
        # Получаем текущее направление сортировки для столбца
        current_sort_order = self.column_sort_order.get(column_index, Qt.AscendingOrder)
        # Переключаем направление сортировки
        if current_sort_order == Qt.AscendingOrder:
            new_sort_order = Qt.DescendingOrder
        else:
            new_sort_order = Qt.AscendingOrder
        self.column_sort_order[column_index] = new_sort_order
        table.sortItems(column_index, new_sort_order)

    def update_second_table(self):
        line = self.ui_dialog.lineEdit.text()
        datetime1 = self.ui_dialog.dateTimeEdit.text()
        datetime2 = self.ui_dialog.dateTimeEdit_2.text()
        line2 = self.ui_dialog.lineEdit_2.text()
        combBox = self.ui_dialog.comboBox.currentText()

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
                self.ui.tableWidget.setItem(selected_row, 1, QTableWidgetItem(line))
                self.ui.tableWidget.setItem(selected_row, 2, QTableWidgetItem(datetime1))
                self.ui.tableWidget.setItem(selected_row, 3, QTableWidgetItem(datetime2))
                self.ui.tableWidget.setItem(selected_row, 4, QTableWidgetItem(line2))
                self.ui.tableWidget.setItem(selected_row, 5, QTableWidgetItem(combBox))

                # TODO: Добавить валидациюы

                # Преобразуем данные в JSON
                dishes_dict = {}  # Предполагается, что line содержит данные в формате "Название:Количество"
                for dish in line2.split(','):
                    name, quantity = dish.split(':')
                    dishes_dict[name.strip()] = int(quantity.strip())

                data = {
                    "id_order": selected_row + 1,
                    "id_worker": 1,
                    "dishes": dishes_dict,
                    "status": combBox,
                    "formation_date": datetime1,
                    "giving_date": datetime2
                }

                # Отправляем данные с помощью функции post_data
                # if self.api.post_data('orders', data) is not None:
                #     print(f'УСПЕШНАЯ ПЕРЕДАЧА | ИЗМЕНЕНИЯ В ЗАКАЗЕ {selected_row + 1}')
                # else:
                #     print(f'[!] ОШИБКА ПЕРЕДАЧИ | ИЗМЕНЕНИЯ В ЗАКАЗЕ {selected_row + 1}')
                print(data)

            self.new_window.close()
        else:
            # Если пользователь отменил действие, ничего не делаем
            pass

    def update_third_table(self):
        combBox = self.ui_dialog2.comboBox.currentText()
        line1 = self.ui_dialog2.lineEdit.text()
        datetime1 = self.ui_dialog2.dateTimeEdit.text()
        datetime2 = self.ui_dialog2.dateTimeEdit_2.text()
        line2 = self.ui_dialog2.lineEdit_2.text()
        line3 = self.ui_dialog2.lineEdit_3.text()
        line4 = self.ui_dialog2.lineEdit_4.text()

        # Создаем диалоговое окно для подтверждения
        confirm_dialog = QMessageBox()
        confirm_dialog.setIcon(QMessageBox.Question)
        confirm_dialog.setText("Вы уверены, что хотите внести изменения в таблицу 'Столы'?")
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
                self.ui.tableWidget_3.setItem(selected_row, 2, QTableWidgetItem(line1))
                self.ui.tableWidget_3.setItem(selected_row, 3, QTableWidgetItem(datetime1))
                self.ui.tableWidget_3.setItem(selected_row, 4, QTableWidgetItem(datetime2))
                self.ui.tableWidget_3.setItem(selected_row, 5, QTableWidgetItem(line2))
                self.ui.tableWidget_3.setItem(selected_row, 6, QTableWidgetItem(line3))
                self.ui.tableWidget_3.setItem(selected_row, 7, QTableWidgetItem(line4))

                # TODO: Добавить валидацию
                data = {
                  "id_table": selected_row+1,
                  "id_worker": line1,
                  "phone_client": line2,
                  "order_time": datetime1,
                  "desired_booking_time": datetime2,
                  "booking_interval": line3
                }
                print(data)

            self.new_window2.close()
        else:
            # Если пользователь отменил действие, ничего не делаем
            pass

    def fill_table_widget(self, tableWidget):

        data = [
            (1, 2, 3, 4, 5, 6),
            (7, 8, 9, 10, 11, 12),
            (1, 2, 3, 4, 5, 6),
        ]

        tableWidget.setRowCount(len(data))
        tableWidget.setColumnCount(len(data[0]))

        for row_idx, row_data in enumerate(data):
            for col_idx, cell_data in enumerate(row_data):
                item = QTableWidgetItem(str(cell_data))
                tableWidget.setItem(row_idx, col_idx, item)

    def commit(self, table):
        with open('ordernum', 'r') as file:
            order_num = file.read() # номер заказа (после нажатия кнопки наверное стоит его увеличить на 1)
        waiter_id = self.ui.lineEdit.text() # id официанта
        print(waiter_id)
        data_dict = {}
        column_count = table.columnCount()

        for row_index in range(table.rowCount()):
            item_id = int(table.item(row_index, 0).text())
            name = table.item(row_index, 1).text()
            count = int(table.item(row_index, 2).text())
            comment = table.item(row_index, 3).text()

            data_dict[str(item_id)] = {"name": name, "count": count, "comment": comment}

        json_data = {"data": data_dict}
        print("Data saved:", json_data)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.new_window3.show()
    sys.exit(app.exec())
