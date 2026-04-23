import 'package:flutter/material.dart';

import 'widgets/preference_editor_screen.dart';

class AllergiesScreen extends StatelessWidget {
  const AllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PreferenceEditorScreen(
      title: 'Allergies',
      description:
          "Add ingredients you're allergic to. We'll exclude recipes containing these items.",
      kind: 'allergy',
      itemIcon: Icons.warning_amber_rounded,
      addButtonLabel: 'Add Allergy',
      inputHint: 'Enter allergy (e.g., Milk)',
    );
  }
}
