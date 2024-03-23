import sys
import os
import platform
from datetime import datetime

from PySide6.QtWidgets import QMainWindow

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

        self.api = ApiConnect()


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

        # SET CUSTOM THEME
        # ///////////////////////////////////////////////////////////////
        self.themeFile = "themes/py_dracula_dark.qss"
        widgets.settingsTopBtn.setStyleSheet("image: url(images/icons/moon.png)")
        self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")

        UIFunctions.theme(self, self.themeFile, True)
        widgets.settingsTopBtn.clicked.connect(lambda: UIFunctions.toggle_theme(self))

        tab1_column_widths = [500, 300]
        UIFunctions.set_column_widths(self, widgets.tableWidget_2, tab1_column_widths)
        widgets.tableWidget_2.horizontalHeader().setSectionResizeMode(0, QHeaderView.Stretch)

        widgets.pushButton.clicked.connect(self.add_order)
        widgets.pushButton_4.clicked.connect(self.add_row_with_combobox)
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

    def add_order(self):
        current_row = self.ui.tableWidget_2.rowCount()
        self.ui.tableWidget_2.insertRow(current_row)

        # Получаем текущее время и форматируем его в строку
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M")

        # Создаем элементы для ячеек таблицы
        order_item = QTableWidgetItem(f"Заказ № {self.order_count + 1}")
        time_item = QTableWidgetItem(current_time)

        # Устанавливаем флаги, чтобы ячейки нельзя было редактировать
        order_item.setFlags(order_item.flags() & ~Qt.ItemIsEditable)
        time_item.setFlags(time_item.flags() & ~Qt.ItemIsEditable)

        # Устанавливаем элементы в таблицу
        self.ui.tableWidget_2.setItem(current_row, 0, order_item)
        self.ui.tableWidget_2.setItem(current_row, 1, time_item)

        # Устанавливаем шрифт для элементов
        font = QFont("Segoe UI", 14)  # Настройте шрифт по вашему желанию
        order_item.setFont(font)
        time_item.setFont(font)

        self.order_added = True
        self.order_count += 1

    def add_row_with_combobox(self):
        if self.order_added:
            current_row = self.ui.tableWidget_2.rowCount()
            self.ui.tableWidget_2.insertRow(current_row)

            self.ui.tableWidget_2.setItem(current_row, 0, QTableWidgetItem(""))

            # Создаем и добавляем комбобокс в ячейку выбора
            combo_box = QComboBox()
            combo_box.addItem("Ожидание")
            combo_box.addItem("Готово")
            combo_box.addItem("Отменено")
            self.ui.tableWidget_2.setCellWidget(current_row, 1, combo_box)
        else:
            # Выводим предупреждение, что сначала нужно добавить заказ
            QMessageBox.warning(self, "Предупреждение", "Сначала добавьте заказ")

    # def insert_tab(self,table):
    #     self.ui.tableWidget_2
    #     self.add_order()
    #     self.add_row_with_combobox()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec())
