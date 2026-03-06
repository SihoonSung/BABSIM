import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  static const _ingredients = [
    '250g pasta (fettuccine or penne)',
    '200ml heavy cream',
    '50g parmesan cheese, grated',
    '2 cloves garlic, minced',
    '2 tbsp butter',
    'Salt and black pepper to taste',
    'Fresh parsley for garnish',
    'Pinch of nutmeg (optional)',
  ];

  static const _instructions = [
    'Cook pasta according to package directions in salted boiling water. Reserve 1 cup of pasta water before draining.',
    'While pasta cooks, melt butter in a large pan over medium heat.',
    'Add minced garlic and saute until fragrant, about 1 minute.',
    'Pour in heavy cream and bring to a gentle simmer.',
    'Add grated parmesan cheese and stir until melted and smooth.',
    'Add drained pasta to the sauce and toss to coat. Add pasta water if needed to adjust consistency.',
    'Season with salt, pepper, and nutmeg if using.',
    'Garnish with fresh parsley and serve immediately.',
  ];

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset(
                    'assets/images/creamy_garlic_pasta.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.0, -0.08),
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
                    const Text(
                      'ITALIAN',
                      style: TextStyle(
                        color: Color(0xFFF0914E),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Creamy Pasta',
                      style: TextStyle(
                        color: Color(0xFF16213D),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A quick and delicious creamy pasta dish\nthat comes together in just 15 minutes.',
                      style: TextStyle(
                        color: Color(0xFF6D798F),
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFE5E7EA), height: 1),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        _MetaItem(
                          icon: Icons.access_time_rounded,
                          label: '15m',
                        ),
                        SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.star_rounded,
                          label: '4.5',
                          iconColor: Color(0xFFF5B300),
                        ),
                        SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.people_outline_rounded,
                          label: '2 servings',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE5E7EA), height: 1),
                    const SizedBox(height: 22),
                    const _SectionTitle(title: 'Ingredients'),
                    const SizedBox(height: 14),
                    _IngredientsCard(items: _ingredients),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Instructions'),
                    const SizedBox(height: 14),
                    ...List.generate(
                      _instructions.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _instructions.length - 1 ? 0 : 16,
                        ),
                        child: _InstructionCard(
                          index: index + 1,
                          text: _instructions[index],
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
