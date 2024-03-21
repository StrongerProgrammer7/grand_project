import sys
import os
import platform
import threading
import time

import schedule
from PySide6.QtWidgets import QMainWindow
from PySide6 import QtWidgets
from datetime import datetime
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

        # SET API WORK
        # ///////////////////////////////////////////////////////////////
        self.api = ApiConnect()

        # Запуск обновления данных каждые 10 минут
        schedule.every(3).hours.do(self.update_json_files)
        schedule.run_pending()
        time.sleep(1)

        # USE CUSTOM TITLE BAR | USE AS "False" FOR MAC OR LINUX
        # ///////////////////////////////////////////////////////////////
        Settings.ENABLE_CUSTOM_TITLE_BAR = True

        # APP NAME
        # ///////////////////////////////////////////////////////////////
        title = "SOLIDSIGN - для официантов"
        description = "SOLIDSIGN APP - Theme with colors based on Dracula for Python."
        # APPLY TEXTS
        # self.setWindowTitle(title)
        # widgets.titleRightInfo.setText(description)

        # TOGGLE MENU
        # ///////////////////////////////////////////////////////////////
        widgets.toggleButton.clicked.connect(lambda: UIFunctions.toggleMenu(self, True))

        # SET UI DEFINITIONS
        # ///////////////////////////////////////////////////////////////
        UIFunctions.uiDefinitions(self)

        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)
        widgets.btn_new.clicked.connect(self.buttonClick)

        # EXTRA LEFT BOX
        # def openCloseLeftBox():
        #    UIFunctions.toggleLeftBox(self, True)

        # widgets.toggleLeftBox.clicked.connect(openCloseLeftBox)
        # widgets.extraCloseColumnBtn.clicked.connect(openCloseLeftBox)

        # EXTRA RIGHT BOX
        # def openCloseRightBox():
        #    UIFunctions.toggleRightBox(self, True)

        # widgets.settingsTopBtn.clicked.connect(openCloseRightBox)

        # SHOW APP
        # ///////////////////////////////////////////////////////////////
        # self.show()
        # SET CUSTOM THEME
        # ///////////////////////////////////////////////////////////////
        self.themeFile = "themes/py_dracula_dark.qss"
        self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")
        UIFunctions.theme(self, self.themeFile, True)

        widgets.label.setStyleSheet("image: url(images/images/logo.png)")
        # widgets.toggleLeftBox.setStyleSheet("background-image: url(images/icons/moon.png)")

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
        widgets.pushButton_2.clicked.connect(lambda: UIFunctions.open_new_window(self))

        # 3 ВКЛАДКА
        widgets.pushButton_9.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget_3))
        widgets.pushButton_8.clicked.connect(lambda: UIFunctions.open_new_window2(self))

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
        self.new_window.show()

    def open_new_window2(self):
        self.new_window2.show()

    def update_json_files(self):
        endpoints = ['get_order_history', 'get_all_booked_tables']  # список всех эндпоинтов, которые нужно обновить

        for endpoint in endpoints:
            data = self.api.get_data(endpoint)
            if data:
                with open(f"../waiter/modules/api/jsons/{endpoint}.json", "w") as file:
                    json.dump(data, file)

    def login(self):
        username = self.ui_dialog3.lineEdit.text()
        password = self.ui_dialog3.lineEdit_2.text()

        # self.curUser = User.authorization(username, password, self.api)
        #
        # if self.curUser is not None:
        #     pass

        if username == "" and password == "":

            self.update_json_files()
            # Создаем и запускаем потоки для заполнения таблиц
            order_thread = threading.Thread(target=self.fill_table_widget, args=(self.ui.tableWidget,))
            table_booking_thread = threading.Thread(target=self.fill_table_widget, args=(self.ui.tableWidget_3,))
            order_thread.start()
            table_booking_thread.start()

            # Ожидаем завершения потоков
            order_thread.join()
            table_booking_thread.join()

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
        msg_box.button(QMessageBox.Yes).setText("Да")  # Замена текста кнопки "Да"
        msg_box.button(QMessageBox.No).setText("Нет")  # Замена текста кнопки "Нет"
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

                # TODO: Добавить валидацию

                # Преобразуем данные в JSON
                dishes_dict = {}  # Предполагается, что line содержит данные в формате "Название:Количество"
                for dish in line2.split(','):
                    name, quantity = dish.split(':')
                    dishes_dict[name.strip()] = int(quantity.strip())

                food_ids = []
                quantities = []
                for food_id, quantity in dishes_dict.items():
                    food_ids.append(int(food_id))
                    quantities.append(quantity)

                data = {
                    "order_id": selected_row + 1,
                    "food_id": food_ids,
                    "quantities": quantities,
                    "status": combBox
                }

                # Отправляем данные с помощью функции post_data
                self.api.post_data('update_orders', data)

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
        msg_box.button(QMessageBox.Yes).setText("Да")  # Замена текста кнопки "Да"
        msg_box.button(QMessageBox.No).setText("Нет")  # Замена текста кнопки "Нет"
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
                    "id_table": selected_row + 1,
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
        if tableWidget.objectName() == 'tableWidget':
            field_mapping = {
                "№": "id_order",
                "Официант": "id_worker",
                "Дата выдачи": "giving_date",
                "Дата формирования": "formation_date",
                "Блюда": "dishes",
                "Статус": "status"
            }
            endpoint = 'get_order_history'
            date_keys = ['formation_date', 'giving_date']
        elif tableWidget.objectName() == 'tableWidget_3':
            field_mapping = {
                "№": "table_id",
                "Официант": "worker_id",
                "Дата заказа": "booking_date",
                "Желаема дата": "desired_date",
                "Номер телефона": "client_number",
                "Интервал брони": "booking_interval"
            }
            endpoint = 'get_all_booked_tables'
            date_keys = ['booking_date', 'desired_date']
        else:
            return  # Если таблица не соответствует ни одному известному типу данных, выходим из функции

        # Загружаем данные из JSON файла
        with open(f"../waiter/modules/api/jsons/{endpoint}.json", "r") as file:
            json_data = json.load(file)

        data = json_data['data'][0]['view_order_history'] if endpoint == 'get_order_history' else json_data['data']

        tableWidget.setRowCount(len(data))
        tableWidget.setColumnCount(len(field_mapping))

        headers = list(field_mapping.keys())

        for row_idx, row_data in enumerate(data):
            for col_idx, header in enumerate(headers):
                key = field_mapping[header]
                if key == "":
                    continue
                if endpoint == 'get_all_booked_tables':
                    if key in date_keys:
                        date_obj = datetime.strptime(row_data[key], "%Y-%m-%dT%H:%M:%S.%fZ")
                        formatted_date = date_obj.strftime("%d.%m.%Y %H:%M:%S")
                        item = QTableWidgetItem(formatted_date)
                    elif key == 'booking_interval':
                        item = QTableWidgetItem(str(row_data[key]['hours']))
                    else:
                        item = QTableWidgetItem(str(row_data[key]))
                elif endpoint == 'get_order_history':
                    if key in date_keys:
                        date_obj = datetime.fromisoformat(row_data[key])
                        formatted_date = date_obj.strftime("%d.%m.%Y %H:%M:%S")
                        item = QTableWidgetItem(formatted_date)
                    elif key == 'dishes':
                        dishes_str = ', '.join([f'{dish}: {qty}' for dish, qty in row_data[key].items()])
                        item = QTableWidgetItem(dishes_str)
                    else:
                        item = QTableWidgetItem(str(row_data[key]))
                else:
                    continue
                tableWidget.setItem(row_idx, col_idx, item)

    def commit(self, table):
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
