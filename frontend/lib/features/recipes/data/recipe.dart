import '../../../core/api/api_client.dart';

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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['title'] as String,
      category: json['category'] as String? ?? 'Korean',
      imageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      cookTimeMinutes: json['cooking_time_minutes'] as int? ?? 0,
      difficulty: _parseDifficulty(json['difficulty'] as String?),
      mealType: _parseMealType(json['meal_type'] as String?),
      dietaryTags: (json['dietary_tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  static Difficulty _parseDifficulty(String? v) {
    switch (v) {
      case 'intermediate': return Difficulty.medium;
      case 'advanced': return Difficulty.hard;
      default: return Difficulty.easy;
    }
  }

  static MealType _parseMealType(String? v) {
    switch (v) {
      case 'breakfast': return MealType.breakfast;
      case 'lunch': return MealType.lunch;
      case 'snack': return MealType.snack;
      default: return MealType.dinner;
    }
  }

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

/// API에서 레시피 목록 가져오기
Future<List<Recipe>> fetchRecipes() async {
  final response = await ApiClient.instance.dio.get('/recipes/');
  final data = response.data as List<dynamic>;
  return data.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
}
