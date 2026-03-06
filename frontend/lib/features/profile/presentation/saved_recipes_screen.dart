import 'package:flutter/material.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const recipes = [
      _SavedRecipe(
        title: 'Kimchi Stew',
        category: 'Korean',
        time: '30 min',
        servings: '2-3 servings',
        savedAgo: 'Saved 2 days ago',
        tags: ['Kimchi', 'Pork', 'Tofu', 'Onion'],
      ),
      _SavedRecipe(
        title: 'Creamy Pasta',
        category: 'Italian',
        time: '15 min',
        servings: '2 servings',
        savedAgo: 'Saved 3 days ago',
        tags: ['Pasta', 'Cream', 'Garlic', 'Parmesan'],
      ),
      _SavedRecipe(
        title: 'Avocado Toast',
        category: 'Western',
        time: '10 min',
        servings: '1 serving',
        savedAgo: 'Saved 5 days ago',
        tags: ['Bread', 'Avocado', 'Egg', 'Tomato'],
      ),
      _SavedRecipe(
        title: 'Fresh Salad Bowl',
        category: 'Healthy',
        time: '10 min',
        servings: '1 serving',
        savedAgo: 'Saved 1 week ago',
        tags: ['Lettuce', 'Chicken', 'Tomato', 'Dressing'],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFF8F3E8),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF8A3B0F),
                        ),
                      ),
                      const Text(
                        'Saved Recipes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A3B0F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search saved recipes...',
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                itemCount: recipes.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _SavedRecipeCard(recipe: recipes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedRecipe {
  final String title;
  final String category;
  final String time;
  final String servings;
  final String savedAgo;
  final List<String> tags;

  const _SavedRecipe({
    required this.title,
    required this.category,
    required this.time,
    required this.servings,
    required this.savedAgo,
    required this.tags,
  });
}

class _SavedRecipeCard extends StatelessWidget {
  final _SavedRecipe recipe;

  const _SavedRecipeCard({required this.recipe});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF19457), Color(0xFFC95F33)],
                    ),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
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
                          color: const Color(0xFFFFE6CC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF0944F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${recipe.time}   ${recipe.servings}',
                        style: const TextStyle(
                          color: Color(0xFF7E8FA9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe.savedAgo,
                        style: const TextStyle(
                          color: Color(0xFF99A8BD),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFF9CB0C9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipe.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6C7D96),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFF2F6)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Start Cooking'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD6DEE9)),
                      foregroundColor: const Color(0xFF46566F),
                    ),
                    child: const Text('View Recipe'),
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
