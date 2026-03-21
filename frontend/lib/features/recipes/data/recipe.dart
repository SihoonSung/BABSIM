/// 레시피 카테고리 목록
const List<String> recipeCategories = [
  'All',
  'Korean',
  'Japanese',
  'Chinese',
  'Italian',
  'Western',
  'Vegan',
];

/// 조리 시간 분류
enum CookingTime {
  quick,   // < 15 min
  medium,  // 15-30 min
  long_,   // > 30 min
}

/// 난이도
enum Difficulty {
  easy,
  medium,
  hard,
}

/// 식사 타입
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

/// 레시피 데이터 모델
class Recipe {
  final int id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int cookTimeMinutes;
  final Difficulty difficulty;
  final MealType mealType;
  final List<String> dietaryTags;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.cookTimeMinutes,
    this.difficulty = Difficulty.easy,
    this.mealType = MealType.dinner,
    this.dietaryTags = const [],
  });

  CookingTime get cookingTime {
    if (cookTimeMinutes < 15) return CookingTime.quick;
    if (cookTimeMinutes <= 30) return CookingTime.medium;
    return CookingTime.long_;
  }
}

/// Dietary preference options
const List<String> dietaryOptions = [
  'Vegan',
  'Vegetarian',
  'Gluten-Free',
  'Dairy-Free',
];

/// 필터 상태 모델
class RecipeFilter {
  final CookingTime? cookingTime;
  final Set<MealType> mealTypes;
  final Set<String> dietaryTags;

  const RecipeFilter({
    this.cookingTime,
    this.mealTypes = const {},
    this.dietaryTags = const {},
  });

  RecipeFilter copyWith({
    CookingTime? Function()? cookingTime,
    Set<MealType>? mealTypes,
    Set<String>? dietaryTags,
  }) {
    return RecipeFilter(
      cookingTime: cookingTime != null ? cookingTime() : this.cookingTime,
      mealTypes: mealTypes ?? this.mealTypes,
      dietaryTags: dietaryTags ?? this.dietaryTags,
    );
  }

  bool get hasActiveFilters =>
      cookingTime != null || mealTypes.isNotEmpty || dietaryTags.isNotEmpty;

  static const empty = RecipeFilter();
}

/// 더미 레시피 데이터
const List<Recipe> dummyRecipes = [
  Recipe(
    id: 1,
    name: 'Kimchi Stew',
    category: 'Korean',
    imageUrl: 'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=400&h=300&fit=crop',
    rating: 4.8,
    cookTimeMinutes: 30,
    difficulty: Difficulty.easy,
    mealType: MealType.dinner,
    dietaryTags: ['Spicy'],
  ),
  Recipe(
    id: 2,
    name: 'Creamy Pasta',
    category: 'Italian',
    imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
    rating: 4.5,
    cookTimeMinutes: 15,
    difficulty: Difficulty.easy,
    mealType: MealType.dinner,
    dietaryTags: ['Vegetarian', 'Dairy-Free'],
  ),
  Recipe(
    id: 3,
    name: 'Avocado Toast',
    category: 'Western',
    imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400&h=300&fit=crop',
    rating: 4.9,
    cookTimeMinutes: 10,
    difficulty: Difficulty.easy,
    mealType: MealType.breakfast,
    dietaryTags: ['Vegan', 'Vegetarian', 'Dairy-Free'],
  ),
  Recipe(
    id: 4,
    name: 'Fresh Salad',
    category: 'Vegan',
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop',
    rating: 4.2,
    cookTimeMinutes: 10,
    difficulty: Difficulty.easy,
    mealType: MealType.lunch,
    dietaryTags: ['Vegan', 'Vegetarian', 'Gluten-Free', 'Dairy-Free'],
  ),
  Recipe(
    id: 5,
    name: 'Bibimbap',
    category: 'Korean',
    imageUrl: 'https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=400&h=300&fit=crop',
    rating: 4.7,
    cookTimeMinutes: 25,
    difficulty: Difficulty.medium,
    mealType: MealType.lunch,
    dietaryTags: ['Gluten-Free'],
  ),
  Recipe(
    id: 6,
    name: 'Miso Ramen',
    category: 'Japanese',
    imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
    rating: 4.6,
    cookTimeMinutes: 40,
    difficulty: Difficulty.medium,
    mealType: MealType.dinner,
    dietaryTags: [],
  ),
  Recipe(
    id: 7,
    name: 'Kung Pao Chicken',
    category: 'Chinese',
    imageUrl: 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&h=300&fit=crop',
    rating: 4.4,
    cookTimeMinutes: 35,
    difficulty: Difficulty.hard,
    mealType: MealType.dinner,
    dietaryTags: ['Spicy'],
  ),
  Recipe(
    id: 8,
    name: 'Sushi Roll',
    category: 'Japanese',
    imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
    rating: 4.8,
    cookTimeMinutes: 45,
    difficulty: Difficulty.hard,
    mealType: MealType.dinner,
    dietaryTags: ['Dairy-Free', 'Gluten-Free'],
  ),
  Recipe(
    id: 9,
    name: 'Pancakes',
    category: 'Western',
    imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop',
    rating: 4.3,
    cookTimeMinutes: 12,
    difficulty: Difficulty.easy,
    mealType: MealType.breakfast,
    dietaryTags: ['Vegetarian'],
  ),
  Recipe(
    id: 10,
    name: 'Mapo Tofu',
    category: 'Chinese',
    imageUrl: 'https://images.unsplash.com/photo-1582452919651-bf6e86babb18?w=400&h=300&fit=crop',
    rating: 4.5,
    cookTimeMinutes: 20,
    difficulty: Difficulty.medium,
    mealType: MealType.dinner,
    dietaryTags: ['Spicy'],
  ),
];
