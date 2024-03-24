class User:
    _instance = None

    def __init__(self, data):
        self.job_role = None
        self.surname = None
        self.first_name = None
        self.patronymic = None
        self.salary = None
        self.email = None
        self.phone = None
        self.job_rate = None  # Хз что это
        self.superuser = False

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    @staticmethod
    def authorization(login, password, api):
        if login and password:
            data = api.get_data('')
            if data:
                return User(data)
        return None

    def registration(self):
        if self.superuser:
            pass
