import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  Recipe _findRecipe() {
    for (final recipe in dummyRecipes) {
      if (recipe.id == recipeId) {
        return recipe;
      }
    }
    return dummyRecipes.first;
  }

  String _toHighResImage(String imageUrl) {
    return imageUrl
        .replaceFirst('w=400', 'w=1200')
        .replaceFirst('h=300', 'h=900');
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _findRecipe();
    final info = _detailByRecipeId[recipe.id] ?? _fallbackDetail;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F3),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 286,
                  width: double.infinity,
                  child: Image.network(
                    _toHighResImage(recipe.imageUrl),
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.0, -0.08),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Container(
                        color: const Color(0xFF2A2B31),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFF0914E),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2B31),
                        alignment: Alignment.center,
                        child: Text(
                          recipe.name,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _OverlayIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => context.pop(),
                        ),
                        const _OverlayIconButton(
                          icon: Icons.favorite_rounded,
                          iconColor: Color(0xFFF49A59),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.category.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFF0914E),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        color: Color(0xFF16213D),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info.description,
                      style: const TextStyle(
                        color: Color(0xFF6D798F),
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFE5E7EA), height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _MetaItem(
                          icon: Icons.access_time_rounded,
                          label: '${recipe.cookTimeMinutes}m',
                        ),
                        const SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.star_rounded,
                          label: recipe.rating.toStringAsFixed(1),
                          iconColor: const Color(0xFFF5B300),
                        ),
                        const SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.people_outline_rounded,
                          label: info.servings,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE5E7EA), height: 1),
                    const SizedBox(height: 22),
                    const _SectionTitle(title: 'Ingredients'),
                    const SizedBox(height: 14),
                    _IngredientsCard(items: info.ingredients),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Instructions'),
                    const SizedBox(height: 14),
                    ...List.generate(
                      info.instructions.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == info.instructions.length - 1
                              ? 0
                              : 16,
                        ),
                        child: _InstructionCard(
                          index: index + 1,
                          text: info.instructions[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  const _OverlayIconButton({
    required this.icon,
    this.onTap,
    this.iconColor = const Color(0xFF39465E),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    this.iconColor = const Color(0xFF93A0B4),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5D6980),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1A2440),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IngredientsCard extends StatelessWidget {
  final List<String> items;

  const _IngredientsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E1DE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: Color(0xFFF0914E),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Color(0xFF5D6980),
                          fontSize: 16,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final int index;
  final String text;

  const _InstructionCard({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E1DE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF0914E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF5D6980),
                fontSize: 16,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeDetailInfo {
  final String description;
  final String servings;
  final List<String> ingredients;
  final List<String> instructions;

  const _RecipeDetailInfo({
    required this.description,
    required this.servings,
    required this.ingredients,
    required this.instructions,
  });
}

const _fallbackDetail = _RecipeDetailInfo(
  description: 'A balanced and tasty meal that is easy to make at home.',
  servings: '2 servings',
  ingredients: [
    'Main ingredients from your pantry',
    '2 tbsp olive oil',
    'Salt and black pepper to taste',
  ],
  instructions: [
    'Prepare all ingredients and preheat your pan.',
    'Cook over medium heat until tender and flavorful.',
    'Season to taste and serve immediately.',
  ],
);

const Map<int, _RecipeDetailInfo> _detailByRecipeId = {
  2: _RecipeDetailInfo(
    description:
        'A quick and delicious creamy pasta dish that comes together in about 15 minutes.',
    servings: '2 servings',
    ingredients: [
      '250g pasta (fettuccine or penne)',
      '200ml heavy cream',
      '50g parmesan cheese, grated',
      '2 cloves garlic, minced',
      '2 tbsp butter',
      'Salt and black pepper to taste',
    ],
    instructions: [
      'Cook pasta in salted boiling water. Reserve a little pasta water.',
      'Melt butter and saute garlic until fragrant.',
      'Add cream and parmesan, then stir until smooth.',
      'Toss in pasta and adjust consistency with pasta water.',
      'Season and serve warm.',
    ],
  ),
  3: _RecipeDetailInfo(
    description:
        'A light avocado toast recipe perfect for brunch or a quick breakfast.',
    servings: '1 serving',
    ingredients: [
      '1 ripe avocado',
      '2 slices sourdough bread',
      '1 egg (optional)',
      'Lemon juice',
      'Salt and chili flakes',
    ],
    instructions: [
      'Toast bread slices until golden.',
      'Mash avocado with lemon juice and a pinch of salt.',
      'Spread avocado on toast and top with egg if desired.',
      'Finish with chili flakes and serve.',
    ],
  ),
  4: _RecipeDetailInfo(
    description:
        'A crisp fresh salad that works great as a side or a healthy lunch.',
    servings: '2 servings',
    ingredients: [
      'Lettuce mix',
      'Cherry tomatoes',
      'Cucumber',
      'Olive oil and lemon dressing',
      'Salt and pepper',
    ],
    instructions: [
      'Wash and dry all vegetables.',
      'Slice tomatoes and cucumber.',
      'Mix vegetables in a large bowl.',
      'Toss with dressing and season to taste.',
    ],
  ),
  6: _RecipeDetailInfo(
    description: 'Comforting miso ramen packed with umami broth and noodles.',
    servings: '2 servings',
    ingredients: [
      '2 packs ramen noodles',
      '2 tbsp miso paste',
      '4 cups broth',
      'Soy sauce and sesame oil',
      'Scallions and boiled egg topping',
    ],
    instructions: [
      'Bring broth to a simmer and dissolve miso paste.',
      'Season with soy sauce and sesame oil.',
      'Cook noodles separately and drain.',
      'Combine noodles with broth and add toppings.',
      'Serve hot.',
    ],
  ),
};
