import 'package:flutter/material.dart';

import 'widgets/preference_editor_screen.dart';

class DislikedIngredientsScreen extends StatelessWidget {
  const DislikedIngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PreferenceEditorScreen(
      title: 'Disliked Ingredients',
      description:
          "Add ingredients you dislike. We'll down-rank recipes that include these items.",
      kind: 'disliked',
      itemIcon: Icons.not_interested_rounded,
      addButtonLabel: 'Add Ingredient',
      inputHint: 'Enter ingredient (e.g., Cilantro)',
    );
  }
}
