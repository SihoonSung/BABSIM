from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import users, fridge, recipes

app = FastAPI(title="BABSIM API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(fridge.router, prefix="/fridge", tags=["fridge"])
app.include_router(recipes.router, prefix="/recipes", tags=["recipes"])


@app.get("/health")
def health_check():
    return {"status": "ok"}
