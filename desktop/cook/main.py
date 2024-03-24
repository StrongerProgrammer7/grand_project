import sys
import os
import platform
import json
from datetime import datetime

from PySide6.QtWidgets import QMainWindow

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

        #self.api = ApiConnect()


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

        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)

        # SHOW APP
        self.show()

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
        if len(rows_to_delete) == 3:
            for row in reversed(rows_to_delete):
                self.ui.tableWidget_2.removeRow(row)
            self.ui.tableWidget_2.removeRow(row - 1)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec())
