import 'package:flutter/foundation.dart';

class SavedRecipesStore {
  static const List<int> defaultSavedRecipeIds = [1, 2, 3, 5, 6, 9, 10];

  static final ValueNotifier<Set<int>> savedRecipeIds = ValueNotifier<Set<int>>(
    defaultSavedRecipeIds.take(6).toSet(),
  );

  static bool isSaved(int recipeId) => savedRecipeIds.value.contains(recipeId);

  static void ensureMinimumSavedRecipes([int minimumCount = 6]) {
    if (savedRecipeIds.value.length >= minimumCount) {
      return;
    }

    final next = Set<int>.from(savedRecipeIds.value);
    for (final recipeId in defaultSavedRecipeIds) {
      next.add(recipeId);
      if (next.length >= minimumCount) {
        break;
      }
    }
    savedRecipeIds.value = next;
  }

  static void toggleSaved(int recipeId) {
    final next = Set<int>.from(savedRecipeIds.value);
    if (!next.add(recipeId)) {
      next.remove(recipeId);
    }
    savedRecipeIds.value = next;
  }
}
