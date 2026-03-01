from sqlalchemy.orm import Session
from typing import Optional

from app.models.recipe import Recipe, RecipeIngredient


def recommend_recipes(
    db: Session,
    fridge_ingredient_ids: list[int],
    cooking_level: Optional[str],
    limit: int,
) -> list[dict]:
    """
    보유 재료 기준으로 레시피를 추천한다.
    match_score = 필수 재료 중 냉장고에 있는 비율 (0.0 ~ 1.0)
    """
    query = db.query(Recipe)
    if cooking_level:
        query = query.filter(Recipe.cooking_level == cooking_level)

    recipes = query.all()
    fridge_set = set(fridge_ingredient_ids)

    scored = []
    for recipe in recipes:
        required = (
            db.query(RecipeIngredient.ingredient_id)
            .filter(
                RecipeIngredient.recipe_id == recipe.id,
                RecipeIngredient.is_optional == False,
            )
            .all()
        )
        required_ids = [r.ingredient_id for r in required]

        if not required_ids:
            continue

        matched = len(fridge_set & set(required_ids))
        score = matched / len(required_ids)

        scored.append({
            "id": recipe.id,
            "title": recipe.title,
            "description": recipe.description,
            "cooking_level": recipe.cooking_level,
            "cooking_time_minutes": recipe.cooking_time_minutes,
            "serving_size": recipe.serving_size,
            "match_score": round(score, 2),
        })

    scored.sort(key=lambda x: x["match_score"], reverse=True)
    return scored[:limit]
