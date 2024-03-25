import json
import sys
import os
import platform
import threading
from datetime import datetime
from modules.LoginWindow import Ui_Dialog3

from PySide6.QtWidgets import QMainWindow
from PySide6 import QtWidgets

# IMPORT / GUI AND MODULES AND WIDGETS
# ///////////////////////////////////////////////////////////////
from modules import *
from widgets import *

os.environ["QT_FONT_DPI"] = "96"  # FIX Problem for High DPI and Scale above 100%

# SET AS GLOBAL WIDGETS
widgets = None

class MainWindow(QMainWindow):
    def __init__(self):
        QMainWindow.__init__(self)

        # SET AS GLOBAL WIDGETS
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        global widgets
        widgets = self.ui

        # USE CUSTOM TITLE BAR | USE AS "False" FOR MAC OR LINUX
        Settings.ENABLE_CUSTOM_TITLE_BAR = True

        self.api = ApiConnect('./fullchain.pem')
        # self.api.connect_to_server()
        # self.api.sio.on('message', self.on_message)

        # APP NAME
        # title = "SOLIDSIGN - для официантов"
        # description = "SOLIDSIGN APP - Theme with colors based on Dracula for Python."
        # APPLY TEXTS
        # self.setWindowTitle(title)
        # widgets.titleRightInfo.setText(description)

        # TOGGLE MENU
        widgets.toggleButton.clicked.connect(lambda: UIFunctions.toggleMenu(self, True))

        # SET UI DEFINITIONS
        UIFunctions.uiDefinitions(self)

        # QTableWidget PARAMETERS
        widgets.tableWidget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        # BUTTONS CLICK
        # SHOW APP
        self.new_window3 = QtWidgets.QDialog()
        self.ui_dialog3 = Ui_Dialog3()
        self.ui_dialog3.setupUi(self.new_window3)
        self.new_window3.setFixedSize(self.new_window3.size())

        self.ui_dialog3.checkBox.stateChanged.connect(self.change_password_visibility)
        self.ui_dialog3.pushButton.clicked.connect(self.login)

        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)


        self.insert_table()

        for row in range(self.ui.tableWidget_2.rowCount()):
            for col in range(1, self.ui.tableWidget_2.columnCount()):
                combo_box = self.ui.tableWidget_2.cellWidget(row, col)
                if combo_box is not None:
                    combo_box.currentIndexChanged.connect(self.check_and_remove_order)

        # SET CUSTOM THEME
        self.themeFile = "themes/py_dracula_dark.qss"
        widgets.settingsTopBtn.setStyleSheet("image: url(images/icons/moon.png)")
        self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")

        UIFunctions.theme(self, self.themeFile, True)
        widgets.settingsTopBtn.clicked.connect(lambda: UIFunctions.toggle_theme(self))

        tab1_column_widths = [500, 300]
        UIFunctions.set_column_widths(self, widgets.tableWidget_2, tab1_column_widths)
        widgets.tableWidget_2.horizontalHeader().setSectionResizeMode(0, QHeaderView.Stretch)

        widgets.pushButton_6.clicked.connect(lambda: UIFunctions.clear_table(self))

        self.order_count = 0
        self.order_added = False

        # DATETIME
        self.timer = QTimer(self)
        self.timer.timeout.connect(lambda: UIFunctions.update_time(self))
        self.timer.start(0)

        # SET HOME PAGE AND SELECT MENU
        # ///////////////////////////////////////////////////////////////
        widgets.stackedWidget.setCurrentWidget(widgets.home)
        widgets.btn_home.setStyleSheet(UIFunctions.selectMenu(widgets.btn_home.styleSheet()))

        self.list_count = 0

    # BUTTONS CLICK
    # Post here your functions for clicked buttons
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
    def resizeEvent(self, event):
        # Update Size Grips
        UIFunctions.resize_grips(self)

    # MOUSE CLICK EVENTS
    def mousePressEvent(self, event):
        # SET DRAG POS WINDOW
        self.dragPos = event.globalPos()

        # PRINT MOUSE EVENTS
        if event.buttons() == Qt.LeftButton:
            print('Mouse click: LEFT CLICK')
        if event.buttons() == Qt.RightButton:
            print('Mouse click: RIGHT CLICK')

    def on_message(self, data):
        self.update_table(data)

    def update_table(self, data):
        # Получаем order_id, новый статус и выбранную строку в таблице
        order_id = data.get("order_id")
        new_status = data.get("status")
        selected_row = order_id - 1  # Индексация строк начинается с 0

        if selected_row >= 0:
            # Устанавливаем новый статус в таблице
            self.ui.tableWidget.setItem(selected_row, 5, QTableWidgetItem(new_status))

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

            # Загружаем данные из JSON файла
            with open(f"./jsons/{endpoint}.json", "r") as file:
                json_data = json.load(file)
            # Загрузка данных меню
            menu_data = {}
            with open("./jsons/get_menu_sorted_by_type.json", "r") as menu_file:
                menu_json = json.load(menu_file)
                for item in menu_json['data']:
                    menu_data[item['food_id']] = item['food_name']

            data = json_data['data'][0]['view_order_history']

            tableWidget.setRowCount(len(data))
            tableWidget.setColumnCount(len(field_mapping))

            headers = list(field_mapping.keys())

            for row_idx, row_data in enumerate(data):
                for col_idx, header in enumerate(headers):
                    key = field_mapping[header]
                    if key == "":
                        continue
                    if endpoint == 'get_order_history':
                        if key in date_keys:
                            date_obj = datetime.fromisoformat(row_data[key])
                            formatted_date = date_obj.strftime("%d.%m.%Y %H:%M:%S")
                            item = QTableWidgetItem(formatted_date)
                        elif key == 'dishes':
                            dishes_str = ', '.join(
                                [f'{menu_data[int(dish)]}: {qty}' for dish, qty in row_data[key].items()])
                            item = QTableWidgetItem(dishes_str)
                        else:
                            item = QTableWidgetItem(str(row_data[key]))
                    else:
                        continue
                    tableWidget.setItem(row_idx, col_idx, item)

    def dishes_count(self):
        with open("order.json", "r", encoding="utf-8") as json_file:
            orders_data = json.load(json_file)["data"]

        dishes_count_list = []
        for order in orders_data:
            count = len(order["dishes"])
            dishes_count_list.append(count)
        print(dishes_count_list)
        return dishes_count_list

    def insert_table(self):
        with open("order.json", "r", encoding="utf-8") as json_file:
            orders_data = json.load(json_file)["data"]
            # Заполнение таблицы данными из JSON
            for order in orders_data:
                row_index = self.ui.tableWidget_2.rowCount()
                self.ui.tableWidget_2.insertRow(row_index)

                # Создаем элементы для ячеек таблицы
                id_order_item = QTableWidgetItem("Заказ № " + str(order["id_order"]))
                giving_date_item = QTableWidgetItem(order["giving_date"])

                # Устанавливаем шрифт для элементов
                font = QFont("Segoe UI", 14)
                id_order_item.setFont(font)
                giving_date_item.setFont(font)

                # Устанавливаем элементы в таблицу
                self.ui.tableWidget_2.setItem(row_index, 0, id_order_item)
                self.ui.tableWidget_2.setItem(row_index, 1, giving_date_item)

                # Получаем статус заказа
                status = order.get("status", "")

                # Добавляем строки для блюд и их количества
                dishes = order.get("dishes", {})

                for dish_id, quantity in dishes.items():
                    dish_name = f"Блюдо {dish_id}, Количество {quantity}"
                    dish_item = QTableWidgetItem(dish_name)

                    # Создаем комбобокс и добавляем варианты из статуса
                    combo_box = QComboBox()
                    combo_box.addItems(["Ожидание", "Готово", "Отдано", "Отменено"])

                    # Если строка находится в первых пяти, разрешаем редактирование
                    if row_index < 4:
                        dish_item.setFlags(dish_item.flags() | Qt.ItemIsEditable)
                        combo_box.setEnabled(True)
                    else:
                        combo_box.setEnabled(False)

                    row_index += 1
                    self.ui.tableWidget_2.insertRow(row_index)
                    self.ui.tableWidget_2.setItem(row_index, 0, dish_item)
                    self.ui.tableWidget_2.setCellWidget(row_index, 1, combo_box)


    def check_and_remove_order(self):
        rows_to_delete = []

        for row in range(self.ui.tableWidget_2.rowCount()):
            combo_box = self.ui.tableWidget_2.cellWidget(row, 1)  # Изменен индекс столбца на 1
            if combo_box is not None:
                if combo_box.currentText() != "Ожидание":
                    rows_to_delete.append(row)

        # Удаление строк в обратном порядке, чтобы индексы не сдвигались
        dishes_count = self.dishes_count()
        if len(rows_to_delete) == dishes_count[self.list_count]:
            self.list_count += 1
            print( self.list_count)
            for row in reversed(rows_to_delete):
                self.ui.tableWidget_2.removeRow(row)
            self.ui.tableWidget_2.removeRow(row - 1)


        row_index = self.ui.tableWidget_2.rowCount() - 1

        # Перебираем строки таблицы для установки редактируемости и активности комбобокса
        for row in range(self.ui.tableWidget_2.rowCount()):
            combo_box = self.ui.tableWidget_2.cellWidget(row, 1)
            if combo_box is not None:
                if row > 4:
                    combo_box.setEnabled(False)  # Запрещаем редактирование комбобокса для первых пяти строк
                else:
                    combo_box.setEnabled(True)  # Разрешаем редактирование комбобокса для остальных строк

    def login(self):
        username = self.ui_dialog3.lineEdit.text()
        password = self.ui_dialog3.lineEdit_2.text()

        # self.curUser = User.authorization(username, password, self.api)
        #
        # if self.curUser is not None:
        #     pass

        if username == "" and password == "":

            try:
                self.api.connect_to_server()
                self.api.sio.on('message', self.on_message)
            except Exception as e:
                print("Unable to connect to the server:", e)

            #self.update_json_files()
            # self.fill_table_widget(self.ui.tableWidget)

            # Создаем и запускаем потоки для заполнения таблиц
            #order_thread = threading.Thread(target=self.fill_table_widget, args=(self.ui.tableWidget,))
            #table_booking_thread = threading.Thread(target=self.fill_table_widget, args=(self.ui.tableWidget_3,))
            #order_thread.start()
            #table_booking_thread.start()

            # Ожидаем завершения потоков
            #order_thread.join()
            #table_booking_thread.join()

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


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.new_window3.show()
    sys.exit(app.exec())
