import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.fridge import FridgeItem, UserFridge
from app.models.ingredient import Ingredient
from app.models.profile import UserPreference, UserProfile, UserSetting
from app.models.recipe import CookedRecipe, CookedRecipePhoto, Recipe, SavedRecipe
from app.seed import SAMPLE_USER_ID

router = APIRouter()


def _get_profile(user_id: uuid.UUID, db: Session) -> UserProfile:
    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="profile not found")
    return profile


@router.get("/sample-user")
def get_sample_user():
    return {"user_id": str(SAMPLE_USER_ID)}


@router.get("/bootstrap/{user_id}")
def get_bootstrap(user_id: uuid.UUID, db: Session = Depends(get_db)):
    profile = _get_profile(user_id, db)
    settings = db.query(UserSetting).filter(UserSetting.user_id == user_id).first()
    preferences = db.query(UserPreference).filter(UserPreference.user_id == user_id).all()
    fridges = db.query(UserFridge).filter(UserFridge.user_id == user_id).all()
    fridge_items = (
        db.query(FridgeItem, Ingredient, UserFridge)
        .join(Ingredient, FridgeItem.ingredient_id == Ingredient.id)
        .outerjoin(UserFridge, FridgeItem.fridge_id == UserFridge.id)
        .filter(FridgeItem.user_id == user_id)
        .all()
    )
    recipes = db.query(Recipe).order_by(Recipe.id).all()
    saved_ids = {
        row.recipe_id
        for row in db.query(SavedRecipe.recipe_id).filter(SavedRecipe.user_id == user_id).all()
    }
    cooked = db.query(CookedRecipe).filter(CookedRecipe.user_id == user_id).all()
    cooked_ids = [row.id for row in cooked]
    photos = (
        db.query(CookedRecipePhoto)
        .filter(CookedRecipePhoto.cooked_recipe_id.in_(cooked_ids))
        .all()
        if cooked_ids
        else []
    )
    photos_by_recipe = {}
    for photo in photos:
        photos_by_recipe.setdefault(photo.cooked_recipe_id, []).append(photo.image_url)

    expiring_items = sorted(
        [
            {
                "id": item.FridgeItem.id,
                "name": item.Ingredient.name_ko,
                "quantity": item.FridgeItem.quantity,
                "days_until_expiry": item.FridgeItem.days_until_expiry,
                "fridge_name": item.UserFridge.name if item.UserFridge else None,
            }
            for item in fridge_items
            if item.FridgeItem.days_until_expiry is not None
        ],
        key=lambda row: row["days_until_expiry"],
    )[:4]

    featured_recipe = next((recipe for recipe in recipes if recipe.id == 2), recipes[0] if recipes else None)

    return {
        "user": {
            "id": str(user_id),
            "display_name": profile.display_name,
            "title": profile.title,
            "email": profile.email,
            "phone": profile.phone,
            "avatar_url": profile.avatar_url,
            "stats": {
                "saved_recipes": len(saved_ids),
                "cooked_recipes": len(cooked),
                "fridges": len(fridges),
            },
        },
        "home": {
            "saved_recipe_count": len(saved_ids),
            "expiring_soon": expiring_items,
            "featured_recipe": (
                {
                    "id": featured_recipe.id,
                    "title": featured_recipe.title,
                    "category": featured_recipe.category,
                    "image_url": featured_recipe.image_url,
                    "rating": featured_recipe.rating,
                    "cooking_time_minutes": featured_recipe.cooking_time_minutes,
                }
                if featured_recipe
                else None
            ),
        },
        "fridges": [
            {
                "id": fridge.id,
                "name": fridge.name,
                "kind": fridge.kind,
                "is_primary": fridge.is_primary,
                "item_count": sum(1 for item in fridge_items if item.FridgeItem.fridge_id == fridge.id),
            }
            for fridge in fridges
        ],
        "fridge_items": [
            {
                "id": item.FridgeItem.id,
                "fridge_id": item.FridgeItem.fridge_id,
                "fridge_name": item.UserFridge.name if item.UserFridge else None,
                "ingredient_id": item.FridgeItem.ingredient_id,
                "name": item.Ingredient.name_ko,
                "category": item.Ingredient.category,
                "quantity": item.FridgeItem.quantity,
                "storage_type": item.FridgeItem.storage_type,
                "days_until_expiry": item.FridgeItem.days_until_expiry,
                "expiry_reminder": item.FridgeItem.expiry_reminder,
            }
            for item in fridge_items
        ],
        "recipes": [
            {
                "id": recipe.id,
                "slug": recipe.slug,
                "title": recipe.title,
                "category": recipe.category,
                "image_url": recipe.image_url,
                "rating": recipe.rating,
                "cook_time_minutes": recipe.cooking_time_minutes,
                "difficulty": recipe.difficulty,
                "meal_type": recipe.meal_type,
                "dietary_tags": recipe.dietary_tags,
                "saved": recipe.id in saved_ids,
            }
            for recipe in recipes
        ],
        "preferences": {
            "allergies": [row.value for row in preferences if row.kind == "allergy"],
            "disliked_ingredients": [row.value for row in preferences if row.kind == "disliked"],
            "kitchen_tools": [row.value for row in preferences if row.kind == "tool"],
        },
        "cooked_recipes": [
            {
                "id": row.id,
                "recipe_id": row.recipe_id,
                "title": row.title,
                "category": row.category,
                "time": row.time_label,
                "servings": row.servings_label,
                "last_cooked": row.last_cooked_label,
                "cooked_count": row.cooked_count_label,
                "stars": row.stars,
                "photos": photos_by_recipe.get(row.id, []),
            }
            for row in cooked
        ],
        "settings": {
            "expiration_alerts": settings.expiration_alerts if settings else True,
            "recipe_suggestions": settings.recipe_suggestions if settings else True,
            "measurement_units": settings.measurement_units if settings else "Metric",
            "language": settings.language if settings else "Korean",
        },
    }
