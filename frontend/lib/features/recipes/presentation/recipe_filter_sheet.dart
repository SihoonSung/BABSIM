import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/recipe.dart';

/// 필터 바텀시트를 표시하는 함수
Future<RecipeFilter?> showRecipeFilterSheet(
  BuildContext context, {
  required RecipeFilter currentFilter,
}) {
  return showModalBottomSheet<RecipeFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RecipeFilterSheet(initialFilter: currentFilter),
  );
}

class RecipeFilterSheet extends StatefulWidget {
  final RecipeFilter initialFilter;

  const RecipeFilterSheet({super.key, required this.initialFilter});

  @override
  State<RecipeFilterSheet> createState() => _RecipeFilterSheetState();
}

class _RecipeFilterSheetState extends State<RecipeFilterSheet> {
  late CookingTime? _cookingTime;
  late Difficulty? _difficulty;
  late Set<MealType> _mealTypes;

  @override
  void initState() {
    super.initState();
    _cookingTime = widget.initialFilter.cookingTime;
    _difficulty = widget.initialFilter.difficulty;
    _mealTypes = Set.from(widget.initialFilter.mealTypes);
  }

  void _resetAll() {
    setState(() {
      _cookingTime = null;
      _difficulty = null;
      _mealTypes = {};
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(RecipeFilter(
      cookingTime: _cookingTime,
      difficulty: _difficulty,
      mealTypes: _mealTypes,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // 핸들
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 헤더
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF666666)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24, indent: 20, endIndent: 20),
              // 필터 내용
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Cooking Time
                    _SectionTitle(icon: '⏱️', label: 'Cooking Time'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _FilterCard(
                          emoji: '⚡',
                          label: 'Quick',
                          subtitle: '< 15 min',
                          isSelected: _cookingTime == CookingTime.quick,
                          onTap: () => setState(() {
                            _cookingTime = _cookingTime == CookingTime.quick ? null : CookingTime.quick;
                          }),
                        ),
                        const SizedBox(width: 10),
                        _FilterCard(
                          emoji: '⏱️',
                          label: 'Medium',
                          subtitle: '15-30 min',
                          isSelected: _cookingTime == CookingTime.medium,
                          onTap: () => setState(() {
                            _cookingTime = _cookingTime == CookingTime.medium ? null : CookingTime.medium;
                          }),
                        ),
                        const SizedBox(width: 10),
                        _FilterCard(
                          emoji: '🕐',
                          label: 'Long',
                          subtitle: '> 30 min',
                          isSelected: _cookingTime == CookingTime.long_,
                          onTap: () => setState(() {
                            _cookingTime = _cookingTime == CookingTime.long_ ? null : CookingTime.long_;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Difficulty
                    _SectionTitle(icon: '👨‍🍳', label: 'Difficulty'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _FilterCard(
                          emoji: '👌',
                          label: 'Easy',
                          isSelected: _difficulty == Difficulty.easy,
                          onTap: () => setState(() {
                            _difficulty = _difficulty == Difficulty.easy ? null : Difficulty.easy;
                          }),
                        ),
                        const SizedBox(width: 10),
                        _FilterCard(
                          emoji: '👍',
                          label: 'Medium',
                          isSelected: _difficulty == Difficulty.medium,
                          onTap: () => setState(() {
                            _difficulty = _difficulty == Difficulty.medium ? null : Difficulty.medium;
                          }),
                        ),
                        const SizedBox(width: 10),
                        _FilterCard(
                          emoji: '🔥',
                          label: 'Hard',
                          isSelected: _difficulty == Difficulty.hard,
                          onTap: () => setState(() {
                            _difficulty = _difficulty == Difficulty.hard ? null : Difficulty.hard;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Meal Type
                    _SectionTitle(icon: '🍽️', label: 'Meal Type'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: MealType.values.map((type) {
                        final label = switch (type) {
                          MealType.breakfast => 'Breakfast',
                          MealType.lunch => 'Lunch',
                          MealType.dinner => 'Dinner',
                          MealType.snack => 'Snack',
                        };
                        final isSelected = _mealTypes.contains(type);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _mealTypes.remove(type);
                              } else {
                                _mealTypes.add(type);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary.withValues(alpha: 0.1)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary.withValues(alpha: 0.3)
                                    : const Color(0xFFE8E8E8),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? AppTheme.primary : const Color(0xFF555555),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    // Dietary Preferences
                    _SectionTitle(icon: '🥗', label: 'Dietary Preferences'),
                    const SizedBox(height: 12),
                    Text(
                      'Coming soon...',
                      style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // 하단 버튼
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _resetAll,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text(
                                'Reset All',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _applyFilters,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primary.withValues(alpha: 0.85),
                                  AppTheme.primary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Apply Filters',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String icon;
  final String label;

  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterCard({
    required this.emoji,
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.4)
                  : const Color(0xFFE0E0E0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.primary : const Color(0xFF333333),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.7)
                        : const Color(0xFF999999),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
