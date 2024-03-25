import sys
import os
import platform
import threading
import time
import ssl

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
        # Путь к вашему SSL-сертификату

        # Создание контекста SSL
        ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        ssl_context.load_verify_locations('./fullchain.pem')

        self.api = ApiConnect(ssl_cert=ssl_context)

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

        # Начинаем отслеживать изменения в файле
        self.file_watcher = QFileSystemWatcher()
        self.file_watcher.fileChanged.connect(self.update_table)

        self.file_path = "order.json"
        self.file_watcher.addPath(self.file_path)
        self.insert_table(self.ui.tableWidget)

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

        self.fill_table_with_menu(file_path="./jsons/get_menu_sorted_by_type.json")

        widgets.addrow_btn.clicked.connect(lambda: UIFunctions.generate_new_row(self))
        widgets.delrow_btn.clicked.connect(lambda: UIFunctions.delete_row(self))
        widgets.clearbtn.clicked.connect(lambda: UIFunctions.clear_table(self))
        widgets.utvrbtn.clicked.connect(lambda: self.commit(widgets.tableWidget_2))

        # 2 ВКЛАДКА
        # widgets.pushButton_3.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget))
        # widgets.pushButton_2.clicked.connect(lambda: UIFunctions.open_new_window(self))

        # 3 ВКЛАДКА
        # widgets.pushButton_9.clicked.connect(lambda: UIFunctions.delete_row_content(self, widgets.tableWidget_3))
        # widgets.pushButton_8.clicked.connect(lambda: UIFunctions.open_new_window2(self))

        self.ui_dialog.addtransbtn.clicked.connect(self.update_second_table)

        tab1_column_widths = [80, 300, 150]
        UIFunctions.set_column_widths(self, widgets.tableWidget_2, tab1_column_widths)

        tab2_column_widths = [500, 300]
        UIFunctions.set_column_widths(self, widgets.tableWidget, tab2_column_widths)
        widgets.tableWidget.horizontalHeader().setSectionResizeMode(0, QHeaderView.Stretch)

        tab3_column_widths = [80, 200, 200, 200, 200, 200, 200, 200]
        UIFunctions.set_column_widths(self, widgets.tableWidget_3, tab3_column_widths)

        # Сортировка таблиц
        self.column_sort_order = {}
        self.connect_sorting_function(widgets.tableWidget)
        self.connect_sorting_function(widgets.tableWidget_2)
        self.connect_sorting_function(widgets.tableWidget_3)

        label2Text = widgets.label_2.text()
        with open('OrderNum', 'r') as file:
            ordernum = file.read()

        widgets.label_2.setText(f"{label2Text} {ordernum}")
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
        selected_row = self.ui.tableWidget.currentRow()
        if selected_row >= 0:  # Проверяем, что строка действительно выбрана
            line2 = self.ui.tableWidget.item(selected_row, 4).text()
            combBox = self.ui.tableWidget.item(selected_row, 5).text()
            self.ui_dialog.lineEdit_2.setText(line2)
            self.ui_dialog.comboBox.setCurrentText(combBox)
        self.new_window.show()

    def open_new_window2(self):
        selected_row = self.ui.tableWidget_3.currentRow()
        if selected_row >= 0:  # Проверяем, что строка действительно выбрана
            line2 = self.ui.tableWidget_3.item(selected_row, 4).text()
            line3 = self.ui.tableWidget_3.item(selected_row, 5).text()
            self.ui_dialog2.lineEdit_2.setText(line2)
            self.ui_dialog2.lineEdit_3.setText(line3)
        self.new_window2.show()

    def update_json_files(self):
        endpoints = ['get_order_history', 'get_all_booked_tables', 'get_menu_sorted_by_type']

        for endpoint in endpoints:
            data = self.api.get_data(endpoint)
            if data:
                with open(f"./jsons/{endpoint}.json", "w") as file:
                    json.dump(data, file)

    def login(self):
        username = self.ui_dialog3.lineEdit.text()
        password = self.ui_dialog3.lineEdit_2.text()

        if self.api.auth({'login': username, 'password': password}):

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
        current_sort_order = self.column_sort_order.get(column_index, Qt.AscendingOrder)
        if current_sort_order == Qt.AscendingOrder:
            new_sort_order = Qt.DescendingOrder
        else:
            new_sort_order = Qt.AscendingOrder
        self.column_sort_order[column_index] = new_sort_order
        table.sortItems(column_index, new_sort_order)

    # def on_message(self, data):
    #     self.update_table(data)
    #
    # def update_table(self, data):
    #     # Получаем order_id, новый статус и выбранную строку в таблице
    #     order_id = data.get("order_id")
    #     new_status = data.get("status")
    #     selected_row = order_id - 1  # Индексация строк начинается с 0
    #
    #     if selected_row >= 0:
    #         # Устанавливаем новый статус в таблице
    #         self.ui.tableWidget.setItem(selected_row, 5, QTableWidgetItem(new_status))

    def update_second_table(self):
        # line = self.ui_dialog.lineEdit.text()
        # datetime1 = self.ui_dialog.dateTimeEdit.text()
        # datetime2 = self.ui_dialog.dateTimeEdit_2.text()
        line2 = self.ui_dialog.lineEdit_2.text()
        combBox = self.ui_dialog.comboBox.currentText()

        # Создаем диалоговое окно для подтверждения
        confirm_dialog = QMessageBox()
        confirm_dialog.setIcon(QMessageBox.Question)
        confirm_dialog.setText("Вы уверены, что хотите внести изменения в таблицу 'Заказы'?")
        confirm_dialog.setWindowTitle("Подтверждение")
        confirm_dialog.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
        # msg_box.button(QMessageBox.Yes).setText("Да")  # Замена текста кнопки "Да"
        # msg_box.button(QMessageBox.No).setText("Нет")  # Замена текста кнопки "Нет"
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
                # self.ui.tableWidget.setItem(selected_row, 1, QTableWidgetItem(line))
                # self.ui.tableWidget.setItem(selected_row, 2, QTableWidgetItem(datetime1))
                # self.ui.tableWidget.setItem(selected_row, 3, QTableWidgetItem(datetime2))
                self.ui.tableWidget.setItem(selected_row, 4, QTableWidgetItem(line2))
                self.ui.tableWidget.setItem(selected_row, 5, QTableWidgetItem(combBox))

                # TODO: Добавить валидацию
                food_ids = []
                quantities = []

                # Загружаем данные меню из JSON файла
                menu_data = {}
                with open("./jsons/get_menu_sorted_by_type.json", "r") as menu_file:
                    menu_json = json.load(menu_file)
                    for item in menu_json['data']:
                        menu_data[item['food_name']] = item['food_id']

                # Преобразуем данные из строки line2 в список food_ids и quantities
                for dish in line2.split(','):
                    dish_name, quantity = dish.split(':')
                    food_id = menu_data.get(dish_name.strip(), "Unknown")
                    food_ids.append(food_id)
                    quantities.append(int(quantity.strip()))

                data = {
                    "order_id": selected_row + 1,
                    "food_id": food_ids,
                    "quantities": quantities,
                    "new_status": combBox
                }

                print(data)

                # Отправляем данные
                # self.api.send_message(json.dumps(data, ensure_ascii=False))
                self.api.post_data('update_order', data)

                self.new_window.close()
            else:
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
                "Дата брони": "start_booking_date",
                "Номер телефона": "client_number",
                "Интервал брони": "interval"
            }
            endpoint = 'get_all_booked_tables'
            date_keys = ['booking_date', 'start_date']
        else:
            return  # Если таблица не соответствует ни одному известному типу данных, выходим из функции

        # Загружаем данные из JSON файла
        with open(f"./jsons/{endpoint}.json", "r") as file:
            json_data = json.load(file)

        # Загрузка данных меню
        menu_data = {}
        with open("./jsons/get_menu_sorted_by_type.json", "r") as menu_file:
            menu_json = json.load(menu_file)
            for item in menu_json['data']:
                menu_data[item['food_id']] = item['food_name']

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
                        if row_data[key] is not None:
                            date_obj = datetime.fromisoformat(row_data[key])
                            formatted_date = date_obj.strftime("%d.%m.%Y %H:%M:%S")
                            item = QTableWidgetItem(formatted_date)
                        else:
                            item = QTableWidgetItem('-')
                    elif key == 'dishes':
                        dishes_str = ', '.join(
                            [f'{menu_data[int(dish)]}: {qty}' for dish, qty in row_data[key].items()])
                        item = QTableWidgetItem(dishes_str)
                    else:
                        item = QTableWidgetItem(str(row_data[key]))
                else:
                    continue
                tableWidget.setItem(row_idx, col_idx, item)

    def commit(self, table):
        worker_id = self.ui.lineEdit.text()
        food_ids = []
        quantities = []
        formation_date = "2024-03-04T10:11:31.718Z"  # Указываем нужное значение для formation_date
        giving_date = "2024-03-04T10:11:31.718Z"  # Указываем нужное значение для giving_date
        status = "Ожидание"  # Указываем нужное значение для status

        menu_data = {}
        with open("./jsons/get_menu_sorted_by_type.json", "r") as menu_file:
            menu_json = json.load(menu_file)
            for item in menu_json['data']:
                menu_data[item['food_name']] = item['food_id']

        # Проверяем, что все строки таблицы заполнены
        for row_index in range(table.rowCount()):
            if (table.item(row_index, 1) is None or table.item(row_index, 2) is None or
                    table.item(row_index, 1).text() == "" or table.item(row_index, 2).text() == ""):
                print(f"Строка {row_index + 1} не полностью заполнена. Отправка заказа невозможна.")
                return

        # Замена названий блюд на их идентификаторы
        for row_index in range(table.rowCount()):
            food_name = table.item(row_index, 1).text()
            food_ids.append(menu_data.get(food_name, "Unknown"))
            quantities.append(int(table.item(row_index, 2).text()))

        # Преобразование формата даты
        formation_datetime = datetime.strptime(formation_date, "%Y-%m-%dT%H:%M:%S.%fZ")
        formatted_formation_date = formation_datetime.strftime("%Y-%m-%d, %H:%M:%S")

        # Преобразование формата даты для giving_date (если необходимо)
        giving_datetime = datetime.strptime(giving_date, "%Y-%m-%dT%H:%M:%S.%fZ")
        formatted_giving_date = giving_datetime.strftime("%Y-%m-%d, %H:%M:%S")

        json_data = {
            "worker_id": worker_id,
            "food_ids": food_ids,
            "quantities": quantities,
            "formation_date": formatted_formation_date,
            "giving_date": formatted_giving_date,
            "status": status,
            "path": "api/add_client_order",
            "method": "POST",
            "send": {
                "name": "povar",
                "id": 2
            }
        }
        # json_data["givig_date"] = datetime.strptime(json_data["givig_date"], "%Y-%m-%dT%H:%M:%S.%fZ").isoformat()
        self.api.send_message(json_data)

        UIFunctions.clear_table(self.ui.tableWidget_2)


    def fill_table_with_menu(self, file_path):
        self.ui.tableWidget_2.clearContents()

        with open(file_path, "r") as menu_file:
            menu_json = json.load(menu_file)
            for item in menu_json['data']:
                food_name = item['food_name']
                food_id = item['food_id']

                row_index = self.ui.tableWidget_2.rowCount()
                self.ui.tableWidget_2.insertRow(row_index)

                # Вставка числа, а не строки
                self.ui.tableWidget_2.setItem(row_index, 0, QTableWidgetItem())
                self.ui.tableWidget_2.item(row_index, 0).setData(Qt.DisplayRole, row_index + 1)

                self.ui.tableWidget_2.setItem(row_index, 1, QTableWidgetItem(food_name))
                self.ui.tableWidget_2.setItem(row_index, 2, QTableWidgetItem())
                self.ui.tableWidget_2.item(row_index, 2).setData(Qt.DisplayRole, food_id)

    def insert_table(self, table):
        with open(self.file_path, "r", encoding="utf-8") as json_file:
            orders_data = json.load(json_file)["data"]
            # Заполнение таблицы данными из JSON
            for order in orders_data:
                self.insert_order_to_table(table, order)

    def insert_order_to_table(self, table, order):
        row_index = table.rowCount()
        table.insertRow(row_index)

        id_order_item = QTableWidgetItem("Заказ № " + str(order["id_order"]))
        giving_date = order["giving_date"]
        formatted_giving_date = datetime.strptime(giving_date, "%Y-%m-%dT%H:%M:%S.%fZ").strftime("%Y-%m-%d %H:%M:%S")
        giving_date_item = QTableWidgetItem(formatted_giving_date)

        font = QFont("Segoe UI", 14)
        id_order_item.setFont(font)
        giving_date_item.setFont(font)

        table.setItem(row_index, 0, id_order_item)
        table.setItem(row_index, 1, giving_date_item)

        status = order.get("status", "")
        dishes = order.get("dishes", {})

        for dish_id, quantity in dishes.items():
            dish_name = f"Блюдо {dish_id}, Количество {quantity}"
            dish_item = QTableWidgetItem(dish_name)

            combo_box = QComboBox()
            combo_box.addItems(["Ожидание", "Готово", "Отдано", "Отменено"])

            if table == self.ui.tableWidget_2:
                if row_index < 4:
                    dish_item.setFlags(dish_item.flags() | Qt.ItemIsEditable)
                    combo_box.setEnabled(True)
                else:
                    combo_box.setEnabled(False)
            else:
                dish_item.setFlags(dish_item.flags() | Qt.ItemIsEditable)
                combo_box.setEnabled(False)
            row_index += 1
            table.insertRow(row_index)
            table.setItem(row_index, 0, dish_item)
            table.setCellWidget(row_index, 1, combo_box)

    def update_table(self):
        # Очищаем таблицу перед обновлением
        self.ui.tableWidget.clearContents()
        self.ui.tableWidget.setRowCount(0)
        # Заполняем таблицу заново
        self.insert_table(self.ui.tableWidget)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.new_window3.show()
    sys.exit(app.exec())
