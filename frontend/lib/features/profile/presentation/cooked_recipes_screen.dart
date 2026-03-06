import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/cooked_recipe_photo_data.dart';

class CookedRecipesScreen extends StatelessWidget {
  const CookedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = cookedRecipePhotoData;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFE7F6F3),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF0F6660),
                        ),
                      ),
                      const Text(
                        'Cooked Recipes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F6660),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () =>
                            context.push('/profile/cooked/gallery'),
                        icon: const Icon(
                          Icons.photo_outlined,
                          color: Color(0xFF22A49A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search cooked recipes...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF8EA0BD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Cooked',
                      value: '171',
                      icon: Icons.soup_kitchen_outlined,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Favorite',
                      value: 'Avocado Toast',
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: recipes.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _CookedCard(
                  recipe: recipes[i],
                  onViewPhotos: () =>
                      context.push('/profile/cooked/photos/${recipes[i].id}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF66C4AB)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6F7F97)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2738),
            ),
          ),
        ],
      ),
    );
  }
}

class _CookedCard extends StatelessWidget {
  final CookedRecipePhotoData recipe;
  final VoidCallback onViewPhotos;

  const _CookedCard({required this.recipe, required this.onViewPhotos});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECF3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    recipe.coverPhoto,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 78,
                      height: 78,
                      color: const Color(0xFFE5EAF0),
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2738),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F6F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5BBE9A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${recipe.time}   ${recipe.servings}',
                        style: const TextStyle(
                          color: Color(0xFF7E8FA9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        recipe.lastCooked,
                        style: const TextStyle(
                          color: Color(0xFF99A8BD),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star_rounded,
                      color: index < recipe.stars
                          ? const Color(0xFFF8B500)
                          : const Color(0xFFCFD8E6),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFF2F6)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Text(
                  recipe.cookedCount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4D5D74),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewPhotos,
                  child: const Text(
                    'View Photos ->',
                    style: TextStyle(
                      color: Color(0xFF66C4AB),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
