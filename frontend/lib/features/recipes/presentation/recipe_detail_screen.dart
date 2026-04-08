import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_client.dart';
import '../data/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? _recipeDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final response = await ApiClient.instance.dio.get('/recipes/${widget.recipeId}');
      if (mounted) {
        setState(() {
          _recipeDetail = response.data as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F4F3),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_recipeDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F4F3),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('레시피를 불러올 수 없어요.')),
      );
    }

    final d = _recipeDetail!;
    final title = d['title'] as String? ?? '';
    final category = d['category'] as String? ?? '';
    final imageUrl = d['image_url'] as String? ?? '';
    final rating = (d['rating'] as num?)?.toDouble() ?? 0.0;
    final cookTime = d['cooking_time_minutes'] as int? ?? 0;
    final servingSize = d['serving_size'] as int? ?? 2;
    final description = d['description'] as String? ?? '';
    final instructions = d['instructions'] as String? ?? '';
    final instructionLines = instructions
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final rawIngredients = d['ingredients'] as List<dynamic>? ?? [];

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
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.0, -0.08),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: const Color(0xFF2A2B31),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFF0914E),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _imageFallback(title),
                        )
                      : _imageFallback(title),
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
                      category.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFF0914E),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF16213D),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xFF6D798F),
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFE5E7EA), height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _MetaItem(
                          icon: Icons.access_time_rounded,
                          label: '${cookTime}m',
                        ),
                        const SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.star_rounded,
                          label: rating.toStringAsFixed(1),
                          iconColor: const Color(0xFFF5B300),
                        ),
                        const SizedBox(width: 18),
                        _MetaItem(
                          icon: Icons.people_outline_rounded,
                          label: '$servingSize servings',
                        ),
                      ],
                    ),
                    if (rawIngredients.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE5E7EA), height: 1),
                      const SizedBox(height: 22),
                      const _SectionTitle(title: 'Ingredients'),
                      const SizedBox(height: 14),
                      _IngredientsCard(
                        items: rawIngredients
                            .map((e) => '${(e as Map)['amount']}')
                            .toList(),
                      ),
                    ],
                    if (instructionLines.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Instructions'),
                      const SizedBox(height: 14),
                      ...List.generate(
                        instructionLines.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == instructionLines.length - 1 ? 0 : 16,
                          ),
                          child: _InstructionCard(
                            index: index + 1,
                            text: instructionLines[index],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback(String title) {
    return Container(
      color: const Color(0xFF2A2B31),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
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
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 4)),
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
                      child: Icon(Icons.circle, size: 6, color: Color(0xFFF0914E)),
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
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 4)),
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
