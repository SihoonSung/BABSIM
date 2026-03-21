import 'package:flutter/material.dart';

import 'widgets/preference_editor_screen.dart';

class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  @override
  Widget build(BuildContext context) {
    return const PreferenceEditorScreen(
      title: 'Allergies',
      description:
          "Add ingredients you're allergic to. We'll exclude recipes containing these items.",
      initialItems: ['Peanuts', 'Shellfish'],
      itemIcon: Icons.warning_amber_rounded,
      addButtonLabel: 'Add Allergy',
      inputHint: 'Enter allergy (e.g., Milk)',
    );
  }
}
