class User:
    def __init__(self, login, password):
        self.job_role = None
        self.surname = None
        self.first_name = None
        self.patronymic = None
        self.salary = None
        self.email = None
        self.phone = None
        self.job_rate = None  # Хз что это

        if self.authorization(login, password):
            pass

        self.superuser = False

    def _convert(self):
        pass

    def authorization(self, login, password):
        data = self._convert()
        return 'Неправильный логин или пароль'

    def registration(self):
        if self.superuser:
            pass
