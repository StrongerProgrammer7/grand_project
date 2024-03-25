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
from PySide6 import QtWidgets
from PySide6.QtCore import QDateTime, QTimer
from PySide6.QtWidgets import QLineEdit, QMessageBox
# MAIN FILE
# ///////////////////////////////////////////////////////////////
from main import *

# GLOBALS
# ///////////////////////////////////////////////////////////////
GLOBAL_STATE = False
GLOBAL_TITLE_BAR = True


class UIFunctions(MainWindow):
    # MAXIMIZE/RESTORE
    # ///////////////////////////////////////////////////////////////
    def maximize_restore(self):
        global GLOBAL_STATE
        status = GLOBAL_STATE
        if status == False:
            self.showMaximized()
            GLOBAL_STATE = True
            self.ui.appMargins.setContentsMargins(0, 0, 0, 0)
            self.ui.maximizeRestoreAppBtn.setToolTip("Restore")
            self.ui.maximizeRestoreAppBtn.setIcon(QIcon(u":/icons/images/icons/icon_restore.png"))
            self.ui.frame_size_grip.hide()
            self.left_grip.hide()
            self.right_grip.hide()
            self.top_grip.hide()
            self.bottom_grip.hide()
        else:
            GLOBAL_STATE = False
            self.showNormal()
            self.resize(self.width() + 1, self.height() + 1)
            self.ui.appMargins.setContentsMargins(10, 10, 10, 10)
            self.ui.maximizeRestoreAppBtn.setToolTip("Maximize")
            self.ui.maximizeRestoreAppBtn.setIcon(QIcon(u":/icons/images/icons/icon_maximize.png"))
            self.ui.frame_size_grip.show()
            self.left_grip.show()
            self.right_grip.show()
            self.top_grip.show()
            self.bottom_grip.show()

    # RETURN STATUS
    # ///////////////////////////////////////////////////////////////
    def returStatus(self):
        return GLOBAL_STATE

    # SET STATUS
    # ///////////////////////////////////////////////////////////////
    def setStatus(self, status):
        global GLOBAL_STATE
        GLOBAL_STATE = status

    # TOGGLE MENU
    # ///////////////////////////////////////////////////////////////
    def toggleMenu(self, enable):
        if enable:
            # GET WIDTH
            width = self.ui.leftMenuBg.width()
            maxExtend = Settings.MENU_WIDTH
            standard = 60

            # SET MAX WIDTH
            if width == 60:
                widthExtended = maxExtend
            else:
                widthExtended = standard

            # ANIMATION
            self.animation = QPropertyAnimation(self.ui.leftMenuBg, b"minimumWidth")
            self.animation.setDuration(Settings.TIME_ANIMATION)
            self.animation.setStartValue(width)
            self.animation.setEndValue(widthExtended)
            self.animation.setEasingCurve(QEasingCurve.InOutQuart)
            self.animation.start()

    # TOGGLE LEFT BOX
    # ///////////////////////////////////////////////////////////////
    def toggleLeftBox(self, enable):
        if enable:
            # GET WIDTH
            width = self.ui.extraLeftBox.width()
            widthRightBox = self.ui.extraRightBox.width()
            maxExtend = Settings.LEFT_BOX_WIDTH
            color = Settings.BTN_LEFT_BOX_COLOR
            standard = 0

            # GET BTN STYLE
            style = self.ui.toggleLeftBox.styleSheet()

            # SET MAX WIDTH
            if width == 0:
                widthExtended = maxExtend
                # SELECT BTN
                self.ui.toggleLeftBox.setStyleSheet(style + color)
                if widthRightBox != 0:
                    style = self.ui.settingsTopBtn.styleSheet()
                    self.ui.settingsTopBtn.setStyleSheet(style.replace(Settings.BTN_RIGHT_BOX_COLOR, ''))
            else:
                widthExtended = standard
                # RESET BTN
                self.ui.toggleLeftBox.setStyleSheet(style.replace(color, ''))

        UIFunctions.start_box_animation(self, width, widthRightBox, "left")

    # TOGGLE RIGHT BOX
    # ///////////////////////////////////////////////////////////////
    def toggleRightBox(self, enable):
        if enable:
            # GET WIDTH
            width = self.ui.extraRightBox.width()
            widthLeftBox = self.ui.extraLeftBox.width()
            maxExtend = Settings.RIGHT_BOX_WIDTH
            color = Settings.BTN_RIGHT_BOX_COLOR
            standard = 0

            # GET BTN STYLE
            style = self.ui.settingsTopBtn.styleSheet()

            # SET MAX WIDTH
            if width == 0:
                widthExtended = maxExtend
                # SELECT BTN
                self.ui.settingsTopBtn.setStyleSheet(style + color)
                if widthLeftBox != 0:
                    style = self.ui.toggleLeftBox.styleSheet()
                    self.ui.toggleLeftBox.setStyleSheet(style.replace(Settings.BTN_LEFT_BOX_COLOR, ''))
            else:
                widthExtended = standard
                # RESET BTN
                self.ui.settingsTopBtn.setStyleSheet(style.replace(color, ''))

            UIFunctions.start_box_animation(self, widthLeftBox, width, "right")

    def start_box_animation(self, left_box_width, right_box_width, direction):
        right_width = 0
        left_width = 0

        # Check values
        if left_box_width == 0 and direction == "left":
            left_width = 240
        else:
            left_width = 0
        # Check values
        if right_box_width == 0 and direction == "right":
            right_width = 240
        else:
            right_width = 0

            # ANIMATION LEFT BOX
        self.left_box = QPropertyAnimation(self.ui.extraLeftBox, b"minimumWidth")
        self.left_box.setDuration(Settings.TIME_ANIMATION)
        self.left_box.setStartValue(left_box_width)
        self.left_box.setEndValue(left_width)
        self.left_box.setEasingCurve(QEasingCurve.InOutQuart)

        # ANIMATION RIGHT BOX        
        self.right_box = QPropertyAnimation(self.ui.extraRightBox, b"minimumWidth")
        self.right_box.setDuration(Settings.TIME_ANIMATION)
        self.right_box.setStartValue(right_box_width)
        self.right_box.setEndValue(right_width)
        self.right_box.setEasingCurve(QEasingCurve.InOutQuart)

        # GROUP ANIMATION
        self.group = QParallelAnimationGroup()
        self.group.addAnimation(self.left_box)
        self.group.addAnimation(self.right_box)
        self.group.start()

    # SELECT/DESELECT MENU
    # ///////////////////////////////////////////////////////////////
    # SELECT
    def selectMenu(getStyle):
        select = getStyle + Settings.MENU_SELECTED_STYLESHEET
        return select

    # DESELECT
    def deselectMenu(getStyle):
        deselect = getStyle.replace(Settings.MENU_SELECTED_STYLESHEET, "")
        return deselect

    # START SELECTION
    def selectStandardMenu(self, widget):
        for w in self.ui.topMenu.findChildren(QPushButton):
            if w.objectName() == widget:
                w.setStyleSheet(UIFunctions.selectMenu(w.styleSheet()))

    # RESET SELECTION
    def resetStyle(self, widget):
        for w in self.ui.topMenu.findChildren(QPushButton):
            if w.objectName() != widget:
                w.setStyleSheet(UIFunctions.deselectMenu(w.styleSheet()))

    # IMPORT THEMES FILES QSS/CSS
    # ///////////////////////////////////////////////////////////////
    def theme(self, file, useCustomTheme):
        if useCustomTheme:
            str = open(file, 'r').read()
            self.ui.styleSheet.setStyleSheet(str)

    def toggle_theme(self):
        current_stylesheet = open(self.themeFile, 'r').read()
        dark_stylesheet = open("themes/py_dracula_dark.qss", 'r').read()
        light_stylesheet = open("themes/py_dracula_light.qss", 'r').read()
        add_view_dark_stylesheet = open("themes/addview_dark.qss", 'r').read()
        add_view_light_stylesheet = open("themes/addview_light.qss", 'r').read()

        if current_stylesheet == dark_stylesheet:
            self.ui.styleSheet.setStyleSheet(light_stylesheet)
            self.ui.titleFrame.setStyleSheet("background-color: #6272a4; color: #f8f8f2; border-radius: 5px")
            self.ui_dialog.stylesheet.setStyleSheet(add_view_light_stylesheet)
            self.ui_dialog2.stylesheet.setStyleSheet(add_view_light_stylesheet)
            self.themeFile = "themes/py_dracula_light.qss"
            self.ui.settingsTopBtn.setStyleSheet("image: url(images/icons/sun.png)")
        else:
            self.ui.styleSheet.setStyleSheet(dark_stylesheet)
            self.ui.titleFrame.setStyleSheet("background-color: rgb(33, 37, 43); color: #f8f8f2; border-radius: 5px")
            self.ui_dialog.stylesheet.setStyleSheet(light_stylesheet)
            self.themeFile = "themes/py_dracula_dark.qss"
            self.ui_dialog.stylesheet.setStyleSheet(add_view_dark_stylesheet)
            self.ui_dialog2.stylesheet.setStyleSheet(add_view_dark_stylesheet)
            self.ui.settingsTopBtn.setStyleSheet("image: url(images/icons/moon.png)")

    def update_time(self):
        current_time = QDateTime.currentDateTime().toString('hh:mm')
        current_date = QDateTime.currentDateTime().toString('dd.MM.yyyy')
        self.ui.time_label.setText(f"{current_time} {current_date}")

    def generate_new_row(self):
        row_index = self.ui.tableWidget_2.rowCount()
        self.ui.tableWidget_2.insertRow(row_index)
        # Вставка индекса в первую ячейку строки
        index_item = QTableWidgetItem(str(row_index + 1))
        index_item.setFlags(index_item.flags() & ~Qt.ItemIsEditable)
        self.ui.tableWidget_2.setItem(row_index, 0, index_item)
        # Заполнение остальных ячеек пустыми значениями
        for column_index in range(1, 4):  # Начинаем с 1, чтобы пропустить первую колонку с индексом
            item = QTableWidgetItem("")
            self.ui.tableWidget_2.setItem(row_index, column_index, item)

    def delete_row(self):
        selected_row = self.ui.tableWidget_2.currentRow()
        if selected_row > 0:
            msg_box = QMessageBox()
            msg_box.setIcon(QMessageBox.Question)
            msg_box.setText("Вы уверены, что хотите удалить эту строку?")
            msg_box.setWindowTitle("Подтверждение удаления")
            msg_box.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
            msg_box.button(QMessageBox.Yes).setText("Да")  # Замена текста кнопки "Да"
            msg_box.button(QMessageBox.No).setText("Нет")  # Замена текста кнопки "Нет"

            # Показываем сообщение и ждем ответа пользователя
            response = msg_box.exec()

            if response == QMessageBox.Yes:
                self.ui.tableWidget_2.removeRow(selected_row)
                # Обновляем индексы для оставшихся строк
                for row_index in range(selected_row, self.ui.tableWidget_2.rowCount()):
                    self.ui.tableWidget_2.item(row_index, 0).setText(str(row_index + 1))

    def clear_table(self):
        msg_box = QMessageBox()
        msg_box.setIcon(QMessageBox.Question)
        msg_box.setText("Вы уверены, что хотите очистить таблицу?")
        msg_box.setWindowTitle("Подтверждение очищения")
        msg_box.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
        msg_box.button(QMessageBox.Yes).setText("Да")  # Замена текста кнопки "Да"
        msg_box.button(QMessageBox.No).setText("Нет")  # Замена текста кнопки "Нет"

        # Показываем сообщение и ждем ответа пользователя
        response = msg_box.exec()

        if response == QMessageBox.Yes:
            self.ui.tableWidget_2.clearContents()
            self.ui.tableWidget_2.setRowCount(0)


    def delete_row_content(self, table):
        selected_row = table.currentRow()
        if selected_row != -1:
            column_count = table.columnCount()
            for column_index in range(column_count):
                item = table.item(selected_row, column_index)
                if item is not None:
                    item.setText("")

    def set_column_widths(self, table_widget, column_widths):
        for column, width in enumerate(column_widths):
            table_widget.setColumnWidth(column, width)


    def load(self):
        pass

    # START - GUI DEFINITIONS
    # ///////////////////////////////////////////////////////////////
    def uiDefinitions(self):
        def dobleClickMaximizeRestore(event):
            # IF DOUBLE CLICK CHANGE STATUS
            if event.type() == QEvent.MouseButtonDblClick:
                QTimer.singleShot(250, lambda: UIFunctions.maximize_restore(self))

        self.ui.titleRightInfo.mouseDoubleClickEvent = dobleClickMaximizeRestore

        if Settings.ENABLE_CUSTOM_TITLE_BAR:
            # STANDARD TITLE BAR
            self.setWindowFlags(Qt.FramelessWindowHint)
            self.setAttribute(Qt.WA_TranslucentBackground)

            # MOVE WINDOW / MAXIMIZE / RESTORE
            def moveWindow(event):
                # IF MAXIMIZED CHANGE TO NORMAL
                if UIFunctions.returStatus(self):
                    UIFunctions.maximize_restore(self)
                # MOVE WINDOW
                if event.buttons() == Qt.LeftButton:
                    self.move(self.pos() + event.globalPos() - self.dragPos)
                    self.dragPos = event.globalPos()
                    event.accept()

            self.ui.titleRightInfo.mouseMoveEvent = moveWindow

            # CUSTOM GRIPS
            self.left_grip = CustomGrip(self, Qt.LeftEdge, True)
            self.right_grip = CustomGrip(self, Qt.RightEdge, True)
            self.top_grip = CustomGrip(self, Qt.TopEdge, True)
            self.bottom_grip = CustomGrip(self, Qt.BottomEdge, True)

        else:
            self.ui.appMargins.setContentsMargins(0, 0, 0, 0)
            self.ui.minimizeAppBtn.hide()
            self.ui.maximizeRestoreAppBtn.hide()
            self.ui.closeAppBtn.hide()
            self.ui.frame_size_grip.hide()

        # DROP SHADOW
        self.shadow = QGraphicsDropShadowEffect(self)
        self.shadow.setBlurRadius(17)
        self.shadow.setXOffset(0)
        self.shadow.setYOffset(0)
        self.shadow.setColor(QColor(0, 0, 0, 150))
        self.ui.bgApp.setGraphicsEffect(self.shadow)

        # RESIZE WINDOW
        self.sizegrip = QSizeGrip(self.ui.frame_size_grip)
        self.sizegrip.setStyleSheet("width: 20px; height: 20px; margin 0px; padding: 0px;")

        # MINIMIZE
        self.ui.minimizeAppBtn.clicked.connect(lambda: self.showMinimized())

        # MAXIMIZE/RESTORE
        self.ui.maximizeRestoreAppBtn.clicked.connect(lambda: UIFunctions.maximize_restore(self))

        # CLOSE APPLICATION
        self.ui.closeAppBtn.clicked.connect(lambda: self.close())

    def resize_grips(self):
        if Settings.ENABLE_CUSTOM_TITLE_BAR:
            self.left_grip.setGeometry(0, 10, 10, self.height())
            self.right_grip.setGeometry(self.width() - 10, 10, 10, self.height())
            self.top_grip.setGeometry(0, 0, self.width(), 10)
            self.bottom_grip.setGeometry(0, self.height() - 10, self.width(), 10)

    # ///////////////////////////////////////////////////////////////
    # END - GUI DEFINITIONS
