import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피 상세'),
      ),
      body: Center(
        child: Text('레시피 #$recipeId'),
      ),
    );
  }
}
