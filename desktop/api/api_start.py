# Этот код является запасным, на случай, если планы резко изменятся
from fastapi import FastAPI

import settings
from router import router

app = FastAPI(title=settings.PROJECT_NAME, version=settings.PROJECT_VERSION)

# ---------------- Роутинг ---------------- #
app.include_router(router)


