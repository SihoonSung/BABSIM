import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../recipes/data/recipe.dart';
import '../../recipes/data/saved_recipes_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: ColoredBox(
        color: const Color(0xFFF2F3F5),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TopHeroSection(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    title: 'Expiring Soon',
                    actionText: 'View All',
                    showAccentDot: true,
                    onActionTap: () => context.go('/fridge'),
                  ),
                ),
                const SizedBox(height: 14),
                const _ExpiringSoonList(),
                const SizedBox(height: 34),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(title: 'For Your Dinner'),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _FeaturedRecipeCard(),
                ),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopHeroSection extends StatelessWidget {
  const _TopHeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFEBC79D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 30),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_Header(), SizedBox(height: 26), _SavedRecipesCard()],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GOOD AFTERNOON',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: Color(0xFF121D3C),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Alex User',
          style: TextStyle(
            fontSize: 31,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101B3B),
          ),
        ),
      ],
    );
  }
}

class _SavedRecipesCard extends StatelessWidget {
  const _SavedRecipesCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/saved-recipes'),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140A1530),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F2F5),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.bookmark_outline_rounded,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Saved Recipes',
                            style: TextStyle(
                              color: Color(0xFF18213D),
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'See your collection',
                            style: TextStyle(
                              color: Color(0xFF7C889E),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFF39A57),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final bool showAccentDot;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.actionText,
    this.showAccentDot = false,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17213B),
              ),
            ),
            if (showAccentDot) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF18B45),
              ),
            ),
          ),
      ],
    );
  }
}

class _ExpiringSoonList extends StatelessWidget {
  const _ExpiringSoonList();

  @override
  Widget build(BuildContext context) {
    const items = [
      _ExpiringItem(
        name: 'Milk',
        daysLeftLabel: '1 day',
        fridgeLabel: 'FRIDGE A',
        illustration: _MilkIllustration(),
      ),
      _ExpiringItem(
        name: 'Spinach',
        daysLeftLabel: '2d',
        fridgeLabel: 'FRIDGE A',
        illustration: _SpinachIllustration(),
      ),
      _ExpiringItem(
        name: 'Eggs',
        daysLeftLabel: '3d',
        fridgeLabel: 'FRIDGE A',
        illustration: _EggIllustration(),
      ),
      _ExpiringItem(
        name: 'Butter',
        daysLeftLabel: '4d',
        fridgeLabel: 'FRIDGE B',
        illustration: _ButterIllustration(),
      ),
    ];

    return SizedBox(
      height: 142,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final String name;
  final String daysLeftLabel;
  final String fridgeLabel;
  final Widget illustration;

  const _ExpiringItem({
    required this.name,
    required this.daysLeftLabel,
    required this.fridgeLabel,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF3),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120D1630),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF09A58),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                daysLeftLabel,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 44,
            child: Align(alignment: Alignment.centerLeft, child: illustration),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18203A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fridgeLabel,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Color(0xFFA3AEC2),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedRecipeCard extends StatefulWidget {
  const _FeaturedRecipeCard();

  @override
  State<_FeaturedRecipeCard> createState() => _FeaturedRecipeCardState();
}

class _FeaturedRecipeCardState extends State<_FeaturedRecipeCard> {
  static const _autoSlideInterval = Duration(seconds: 4);
  static const List<_FeaturedRecipeEntry> _entries = [
    _FeaturedRecipeEntry(
      recipeId: 2,
      matchLabel: '95% Match',
      usesLabel: 'Uses: Milk, Garlic, Butter',
    ),
    _FeaturedRecipeEntry(
      recipeId: 3,
      matchLabel: '93% Match',
      usesLabel: 'Uses: Avocado, Bread, Egg',
    ),
    _FeaturedRecipeEntry(
      recipeId: 4,
      matchLabel: '90% Match',
      usesLabel: 'Uses: Lettuce, Tomato, Cucumber',
    ),
    _FeaturedRecipeEntry(
      recipeId: 6,
      matchLabel: '91% Match',
      usesLabel: 'Uses: Noodles, Broth, Miso',
    ),
  ];

  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }
      final nextIndex = (_currentIndex + 1) % _entries.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _goToIndex(int index) {
    if (!_pageController.hasClients) {
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
    _startAutoSlide();
  }

  Recipe _findRecipe(int recipeId) {
    for (final recipe in dummyRecipes) {
      if (recipe.id == recipeId) {
        return recipe;
      }
    }
    return dummyRecipes.first;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _entries.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final recipe = _findRecipe(entry.recipeId);
                return _FeaturedRecipeSlide(recipe: recipe, entry: entry);
              },
            ),
            Positioned(
              top: 20,
              right: 16,
              child: Column(
                children: List.generate(_entries.length, (index) {
                  final isActive = _currentIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: GestureDetector(
                      onTap: () => _goToIndex(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: isActive ? 12 : 8,
                        height: isActive ? 12 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFF39A57)
                              : Colors.white.withValues(alpha: 0.78),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedRecipeSlide extends StatelessWidget {
  const _FeaturedRecipeSlide({required this.recipe, required this.entry});

  final Recipe recipe;
  final _FeaturedRecipeEntry entry;

  String _toHighResImage(String imageUrl) {
    return imageUrl
        .replaceFirst('w=400', 'w=1200')
        .replaceFirst('h=300', 'h=900');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            _toHighResImage(recipe.imageUrl),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                color: const Color(0xFF2B2A31),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFF39A57),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2B2A31),
                alignment: Alignment.center,
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.26),
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF8EE5C5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: Color(0xFFFFD65C),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.matchLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 245),
                child: Row(
                  children: [
                    const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 15,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        entry.usesLabel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => context.push('/recipes/${recipe.id}'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFF39855),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Start Cooking',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<Set<int>>(
                    valueListenable: SavedRecipesStore.savedRecipeIds,
                    builder: (context, savedRecipeIds, child) {
                      final isSaved = savedRecipeIds.contains(recipe.id);
                      return GestureDetector(
                        onTap: () => SavedRecipesStore.toggleSaved(recipe.id),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF58473B,
                            ).withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            isSaved
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isSaved
                                ? const Color(0xFFF39A57)
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedRecipeEntry {
  const _FeaturedRecipeEntry({
    required this.recipeId,
    required this.matchLabel,
    required this.usesLabel,
  });

  final int recipeId;
  final String matchLabel;
  final String usesLabel;
}

class _MilkIllustration extends StatelessWidget {
  const _MilkIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 3,
            child: Container(
              width: 18,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE2E2DE)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 22,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF7F7F5), Color(0xFFE3E2DD)],
                ),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD2D2CE)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinachIllustration extends StatelessWidget {
  const _SpinachIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 42,
      child: CustomPaint(painter: _SpinachPainter()),
    );
  }
}

class _EggIllustration extends StatelessWidget {
  const _EggIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _ButterIllustration extends StatelessWidget {
  const _ButterIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD96F),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 36,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFF3C853),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinachPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()..color = const Color(0xFF4F9A39);
    final stemPaint = Paint()
      ..color = const Color(0xFF2F6A1E)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final leftLeaf = Path()
      ..moveTo(size.width * 0.45, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.70,
        size.width * 0.14,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.10,
        size.width * 0.46,
        size.height * 0.12,
      )
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.58,
        size.width * 0.45,
        size.height * 0.92,
      );

    final rightLeaf = Path()
      ..moveTo(size.width * 0.46, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.70,
        size.width * 0.84,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.10,
        size.width * 0.48,
        size.height * 0.14,
      )
      ..quadraticBezierTo(
        size.width * 0.44,
        size.height * 0.56,
        size.width * 0.46,
        size.height * 0.92,
      );

    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.18),
      Offset(size.width * 0.46, size.height * 0.95),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
