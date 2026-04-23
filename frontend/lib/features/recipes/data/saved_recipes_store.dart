import 'package:flutter/foundation.dart';

class SavedRecipesStore {
  static final ValueNotifier<Set<int>> savedRecipeIds =
      ValueNotifier<Set<int>>({});

  static bool isSaved(int recipeId) => savedRecipeIds.value.contains(recipeId);

  static void toggleSaved(int recipeId) {
    final next = Set<int>.from(savedRecipeIds.value);
    if (!next.add(recipeId)) {
      next.remove(recipeId);
    }
    savedRecipeIds.value = next;
  }
}
