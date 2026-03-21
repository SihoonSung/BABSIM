import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/cooked_recipe_photo_data.dart';

class CookedRecipesScreen extends StatelessWidget {
  const CookedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = cookedRecipePhotoData;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFEAF8F4),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(18),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Color(0xFF69CBB3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Cooked Recipes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF182136),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/profile/cooked/gallery'),
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: Color(0xFF69CBB3),
                          size: 22,
                        ),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search cooked recipes...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA2AFBF),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFFA2AFBF),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFCBEDE3),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Cooked',
                      value: '171',
                      icon: Icons.soup_kitchen_outlined,
                      accentColor: Color(0xFF69CBB3),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Most Cooked',
                      value: 'Avocado Toast',
                      icon: Icons.emoji_events_outlined,
                      accentColor: Color(0xFFF5B23C),
                      compactValue: true,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '16 Recipes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5E6E87),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
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
  final Color accentColor;
  final bool compactValue;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.compactValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7ECF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E111827),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8A98AE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: compactValue ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compactValue ? 14 : 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1B2436),
              height: 1.15,
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E111827),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        recipe.coverPhoto,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7EDF4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.hide_image_outlined,
                            color: Color(0xFF7A889D),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF69CBB3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.soup_kitchen_outlined,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B2436),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F7F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF67C9B1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Color(0xFFA1AEC0),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              recipe.lastCooked,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A2B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFF2F6)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  size: 16,
                  color: Color(0xFF69CBB3),
                ),
                const SizedBox(width: 6),
                Text(
                  recipe.cookedCount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E4D63),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewPhotos,
                  child: const Text(
                    'View Photos ->',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF69CBB3),
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
