import 'package:flutter/material.dart';

import 'widgets/preference_editor_screen.dart';

class DislikedIngredientsScreen extends StatefulWidget {
  const DislikedIngredientsScreen({super.key});

  @override
  State<DislikedIngredientsScreen> createState() =>
      _DislikedIngredientsScreenState();
}

class _DislikedIngredientsScreenState extends State<DislikedIngredientsScreen> {
  @override
  Widget build(BuildContext context) {
    return const PreferenceEditorScreen(
      title: 'Disliked Ingredients',
      description:
          "Add ingredients you dislike. We'll down-rank recipes that include these items.",
      initialItems: ['Eggplant', 'Cucumber'],
      itemIcon: Icons.not_interested_rounded,
      addButtonLabel: 'Add Ingredient',
      inputHint: 'Enter ingredient (e.g., Cilantro)',
    );
  }
}
