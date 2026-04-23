from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import app as app_routes
from app.api.routes import users, fridge, recipes, auth, preferences
from app.database import Base, SessionLocal, engine
from app.models import fridge as fridge_models
from app.models import ingredient as ingredient_models
from app.models import profile as profile_models
from app.models import recipe as recipe_models
from app.models import user as user_models
from app.seed import seed_sample_data

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
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(app_routes.router, prefix="/app", tags=["app"])
app.include_router(preferences.router, prefix="/preferences", tags=["preferences"])


@app.on_event("startup")
def startup():
    _ = (
        user_models,
        fridge_models,
        ingredient_models,
        profile_models,
        recipe_models,
    )
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed_sample_data(db)
    finally:
        db.close()


@app.get("/health")
def health_check():
    return {"status": "ok"}
