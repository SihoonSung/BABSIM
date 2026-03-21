import 'package:flutter/material.dart';

import 'widgets/preference_editor_screen.dart';

class KitchenToolsScreen extends StatefulWidget {
  const KitchenToolsScreen({super.key});

  @override
  State<KitchenToolsScreen> createState() => _KitchenToolsScreenState();
}

class _KitchenToolsScreenState extends State<KitchenToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return const PreferenceEditorScreen(
      title: 'Kitchen Tools',
      description:
          "Add kitchen tools you own. We'll suggest recipes you can make with your equipment.",
      initialItems: ['Air Fryer', 'Blender'],
      itemIcon: Icons.blender_outlined,
      addButtonLabel: 'Add Kitchen Tool',
      inputHint: 'Enter tool (e.g., Instant Pot)',
    );
  }
}
