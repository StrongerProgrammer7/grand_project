from desktop.my_personal_data import *

PROJECT_NAME = 'PostgreConn'
PROJECT_VERSION = '0.1'
DATABASE_URI = f'postgresql://{USERNAME}:{PASSWORD}@{IP}:{PORT}/{DATABASE_NAME}'
# DATABASE_URI = f'postgresql+psycopg2://{USERNAME}:{PASSWORD}@{IP}:{PORT}/{DATABASE_NAME}'
TEST_URL = f"https://{DOMEN}/api/test"
SERVER_URL = f"https://{DOMEN}/api/"
