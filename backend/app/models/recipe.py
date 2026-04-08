from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Float, JSON, Uuid, func

from app.database import Base


class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String, nullable=False)
    slug = Column(String, unique=True)
    category = Column(String, nullable=False, default="Korean")
    description = Column(String)
    cooking_level = Column(String, nullable=False)
    difficulty = Column(String, nullable=False, default="easy")
    meal_type = Column(String, nullable=False, default="dinner")
    dietary_tags = Column(JSON, nullable=False, default=list)
    rating = Column(Float, nullable=False, default=0.0)
    cooking_time_minutes = Column(Integer)
    serving_size = Column(Integer)
    instructions = Column(String, nullable=False)
    instructions_en = Column(String)
    source = Column(String)
    image_url = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id = Column(Integer, primary_key=True, autoincrement=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    ingredient_id = Column(Integer, ForeignKey("ingredients.id"), nullable=False)
    amount = Column(String, nullable=False)
    is_optional = Column(Boolean, nullable=False, default=False)


class SavedRecipe(Base):
    __tablename__ = "saved_recipes"

    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"), primary_key=True)
    saved_at = Column(DateTime(timezone=True), server_default=func.now())


class CookedRecipe(Base):
    __tablename__ = "cooked_recipes"

    id = Column(String, primary_key=True)
    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="SET NULL"), nullable=True)
    title = Column(String, nullable=False)
    category = Column(String, nullable=False)
    time_label = Column(String, nullable=False)
    servings_label = Column(String, nullable=False)
    last_cooked_label = Column(String, nullable=False)
    cooked_count_label = Column(String, nullable=False)
    stars = Column(Integer, nullable=False, default=0)


class CookedRecipePhoto(Base):
    __tablename__ = "cooked_recipe_photos"

    id = Column(Integer, primary_key=True, autoincrement=True)
    cooked_recipe_id = Column(String, ForeignKey("cooked_recipes.id", ondelete="CASCADE"), nullable=False)
    image_url = Column(String, nullable=False)
