-- BABSIM Database Schema
-- PostgreSQL (Supabase)

-- users
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    nickname TEXT NOT NULL,
    cooking_level TEXT CHECK (cooking_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL DEFAULT 'beginner',
    auth_provider TEXT NOT NULL DEFAULT 'local',
    provider_user_id TEXT UNIQUE,
    avatar_url TEXT,
    password_hash TEXT,
    reset_password_token_hash TEXT,
    reset_password_expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ingredients
CREATE TABLE IF NOT EXISTS ingredients (
    id SERIAL PRIMARY KEY,
    name_ko TEXT NOT NULL,
    name_en TEXT,
    category TEXT NOT NULL,
    us_availability BOOLEAN NOT NULL DEFAULT true
);

-- user's fridge
CREATE TABLE IF NOT EXISTS fridge_items (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    quantity TEXT,
    added_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, ingredient_id)
);

-- recipes
CREATE TABLE IF NOT EXISTS recipes (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    cooking_level TEXT CHECK (cooking_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL,
    cooking_time_minutes INTEGER,
    serving_size INTEGER,
    instructions TEXT NOT NULL,
    instructions_en TEXT,
    source TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- recipe ingredients
CREATE TABLE IF NOT EXISTS recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    amount TEXT NOT NULL,
    is_optional BOOLEAN NOT NULL DEFAULT false
);

-- saved recipes
CREATE TABLE IF NOT EXISTS saved_recipes (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    saved_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, recipe_id)
);

-- indexes
CREATE INDEX IF NOT EXISTS idx_fridge_items_user_id ON fridge_items(user_id);
CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe_id ON recipe_ingredients(recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_ingredient_id ON recipe_ingredients(ingredient_id);
CREATE INDEX IF NOT EXISTS idx_recipes_cooking_level ON recipes(cooking_level);
