from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
import uuid

from app.database import get_db
from app.models.recipe import Recipe, RecipeIngredient, SavedRecipe
from app.models.fridge import FridgeItem
from app.services.recommender import recommend_recipes

router = APIRouter()


class RecipeResponse(BaseModel):
    id: int
    title: str
    slug: Optional[str]
    category: str
    description: Optional[str]
    cooking_level: str
    difficulty: str
    meal_type: str
    dietary_tags: list[str]
    rating: float
    cooking_time_minutes: Optional[int]
    serving_size: Optional[int]
    match_score: float  # 0.0 ~ 1.0, 보유 재료로 커버되는 비율

    class Config:
        from_attributes = True


@router.get("/recommend/{user_id}", response_model=list[RecipeResponse])
def get_recommendations(
    user_id: uuid.UUID,
    cooking_level: Optional[str] = Query(None),
    limit: int = Query(10, le=50),
    db: Session = Depends(get_db),
):
    fridge_ingredient_ids = [
        row.ingredient_id
        for row in db.query(FridgeItem.ingredient_id).filter(FridgeItem.user_id == user_id).all()
    ]

    results = recommend_recipes(
        db=db,
        fridge_ingredient_ids=fridge_ingredient_ids,
        cooking_level=cooking_level,
        limit=limit,
    )
    return results


@router.get("/", response_model=list[RecipeResponse])
def list_recipes(db: Session = Depends(get_db)):
    recipes = db.query(Recipe).order_by(Recipe.id).all()
    return [
        {
            "id": recipe.id,
            "title": recipe.title,
            "slug": recipe.slug,
            "category": recipe.category,
            "description": recipe.description,
            "cooking_level": recipe.cooking_level,
            "difficulty": recipe.difficulty,
            "meal_type": recipe.meal_type,
            "dietary_tags": recipe.dietary_tags or [],
            "rating": recipe.rating,
            "cooking_time_minutes": recipe.cooking_time_minutes,
            "serving_size": recipe.serving_size,
            "match_score": 0.0,
        }
        for recipe in recipes
    ]


@router.get("/saved/{user_id}", response_model=list[RecipeResponse])
def list_saved_recipes(user_id: uuid.UUID, db: Session = Depends(get_db)):
    recipes = (
        db.query(Recipe)
        .join(SavedRecipe, SavedRecipe.recipe_id == Recipe.id)
        .filter(SavedRecipe.user_id == user_id)
        .order_by(Recipe.id)
        .all()
    )
    return [
        {
            "id": recipe.id,
            "title": recipe.title,
            "slug": recipe.slug,
            "category": recipe.category,
            "description": recipe.description,
            "cooking_level": recipe.cooking_level,
            "difficulty": recipe.difficulty,
            "meal_type": recipe.meal_type,
            "dietary_tags": recipe.dietary_tags or [],
            "rating": recipe.rating,
            "cooking_time_minutes": recipe.cooking_time_minutes,
            "serving_size": recipe.serving_size,
            "match_score": 0.0,
        }
        for recipe in recipes
    ]


@router.get("/{recipe_id}")
def get_recipe(recipe_id: int, db: Session = Depends(get_db)):
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="recipe not found")

    ingredients = (
        db.query(RecipeIngredient)
        .filter(RecipeIngredient.recipe_id == recipe_id)
        .all()
    )

    return {
        "id": recipe.id,
        "title": recipe.title,
        "slug": recipe.slug,
        "category": recipe.category,
        "description": recipe.description,
        "cooking_level": recipe.cooking_level,
        "difficulty": recipe.difficulty,
        "meal_type": recipe.meal_type,
        "dietary_tags": recipe.dietary_tags or [],
        "rating": recipe.rating,
        "cooking_time_minutes": recipe.cooking_time_minutes,
        "serving_size": recipe.serving_size,
        "instructions": recipe.instructions,
        "image_url": recipe.image_url,
        "ingredients": [
            {"ingredient_id": i.ingredient_id, "amount": i.amount, "is_optional": i.is_optional}
            for i in ingredients
        ],
    }
