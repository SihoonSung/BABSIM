-- BABSIM Database Schema
-- PostgreSQL (Supabase)

-- 사용자
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    nickname TEXT NOT NULL,
    cooking_level TEXT CHECK (cooking_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL DEFAULT 'beginner',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 재료 카탈로그 (전체 재료 목록)
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name_ko TEXT NOT NULL,           -- 한국어 이름 (예: 계란)
    name_en TEXT,                    -- 영어 이름 (예: egg)
    category TEXT NOT NULL,          -- 채소 / 육류 / 유제품 / 양념 / 곡물 / 기타
    us_availability BOOLEAN NOT NULL DEFAULT true  -- 미국 한국 마트에서 구할 수 있는지
);

-- 사용자 냉장고 (유저가 보유한 재료)
CREATE TABLE fridge_items (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    quantity TEXT,                   -- 자유 텍스트 (예: "2개", "반 팩")
    added_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, ingredient_id)
);

-- 레시피
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    cooking_level TEXT CHECK (cooking_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL,
    cooking_time_minutes INTEGER,    -- 조리 시간 (분)
    serving_size INTEGER,            -- 인분
    instructions TEXT NOT NULL,      -- 조리 순서 (줄바꿈 구분)
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 레시피 필요 재료 (레시피 <-> 재료 다대다)
CREATE TABLE recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    amount TEXT NOT NULL,            -- 예: "2개", "200g", "1큰술"
    is_optional BOOLEAN NOT NULL DEFAULT false  -- 없어도 되는 재료인지
);

-- 사용자 즐겨찾기 레시피
CREATE TABLE saved_recipes (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    saved_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, recipe_id)
);

-- 인덱스
CREATE INDEX idx_fridge_items_user_id ON fridge_items(user_id);
CREATE INDEX idx_recipe_ingredients_recipe_id ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_ingredient_id ON recipe_ingredients(ingredient_id);
CREATE INDEX idx_recipes_cooking_level ON recipes(cooking_level);
