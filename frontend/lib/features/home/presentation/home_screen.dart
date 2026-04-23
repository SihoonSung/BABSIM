import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../fridge/data/fridge_item.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_Header(), SizedBox(height: 26), _SavedRecipesCard()],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final Future<String> _nicknameFuture;

  @override
  void initState() {
    super.initState();
    _nicknameFuture = _fetchNickname();
  }

  Future<String> _fetchNickname() async {
    try {
      final response = await ApiClient.instance.dio.get('/auth/me');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final nickname = data['nickname'] as String?;
        if (nickname != null && nickname.trim().isNotEmpty) {
          return nickname;
        }
      }
    } catch (_) {}
    return 'User';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 18) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _nicknameFuture,
      builder: (context, snapshot) {
        final nickname = snapshot.data ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: const TextStyle(
                fontSize: 12,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
                color: Color(0xFF121D3C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              nickname.isNotEmpty ? nickname : '...',
              style: const TextStyle(
                fontSize: 31,
                height: 1,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101B3B),
              ),
            ),
          ],
        );
      },
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

// 만료 임박 재료 목록 — 서버에서 가져온다
class _ExpiringSoonList extends StatefulWidget {
  const _ExpiringSoonList();

  @override
  State<_ExpiringSoonList> createState() => _ExpiringSoonListState();
}

class _ExpiringSoonListState extends State<_ExpiringSoonList> {
  List<FridgeItem> _items = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId == null) {
        if (mounted) setState(() => _loaded = true);
        return;
      }
      final response = await ApiClient.instance.dio.get('/fridge/$userId');
      final data = response.data as List<dynamic>;
      final items = data
          .map((e) => FridgeItem.fromJson(e as Map<String, dynamic>))
          .where((e) => e.daysUntilExpiry != null && e.daysUntilExpiry! <= 7)
          .toList()
        ..sort((a, b) => (a.daysUntilExpiry ?? 999)
            .compareTo(b.daysUntilExpiry ?? 999));
      if (mounted) {
        setState(() {
          _items = items.take(8).toList();
          _loaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const SizedBox(
        height: 142,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_items.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'No items expiring soon',
            style: TextStyle(color: Color(0xFFA3AEC2), fontSize: 14),
          ),
        ),
      );
    }
    return SizedBox(
      height: 142,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          final days = item.daysUntilExpiry!;
          final emoji = categoryEmojis[item.category] ?? '🫙';
          return _ExpiringItem(
            name: item.name,
            daysLeftLabel: days == 1 ? '1 day' : '${days}d',
            emoji: emoji,
          );
        },
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final String name;
  final String daysLeftLabel;
  final String emoji;

  const _ExpiringItem({
    required this.name,
    required this.daysLeftLabel,
    required this.emoji,
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18203A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Featured 레시피 카드 — 서버에서 레시피를 가져와 상위 4개 표시
class _FeaturedRecipeCard extends StatefulWidget {
  const _FeaturedRecipeCard();

  @override
  State<_FeaturedRecipeCard> createState() => _FeaturedRecipeCardState();
}

class _FeaturedRecipeCardState extends State<_FeaturedRecipeCard> {
  static const _autoSlideInterval = Duration(seconds: 4);

  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentIndex = 0;
  List<Recipe> _recipes = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await fetchRecipes();
      if (mounted) {
        setState(() {
          _recipes = recipes.take(4).toList();
          _loaded = true;
        });
        if (_recipes.isNotEmpty) _startAutoSlide();
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
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
      if (!mounted || !_pageController.hasClients || _recipes.isEmpty) return;
      final nextIndex = (_currentIndex + 1) % _recipes.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _goToIndex(int index) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
    _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 300,
          color: const Color(0xFF2B2A31),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFF39A57),
          ),
        ),
      );
    }
    if (_recipes.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 180,
          color: const Color(0xFF2B2A31),
          alignment: Alignment.center,
          child: const Text(
            'No recipes yet',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _recipes.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return _FeaturedRecipeSlide(recipe: _recipes[index]);
              },
            ),
            Positioned(
              top: 20,
              right: 16,
              child: Column(
                children: List.generate(_recipes.length, (index) {
                  final isActive = _currentIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _goToIndex(index),
                      child: Container(
                        width: 28,
                        height: 28,
                        color: Colors.transparent,
                        alignment: Alignment.center,
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
  const _FeaturedRecipeSlide({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: recipe.imageUrl.isNotEmpty
              ? Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFF2B2A31),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFF39A57),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
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
                  ),
                )
              : Container(
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
              const SizedBox(height: 6),
              Text(
                recipe.category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
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
                            color: const Color(0xFF58473B).withValues(alpha: 0.7),
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
