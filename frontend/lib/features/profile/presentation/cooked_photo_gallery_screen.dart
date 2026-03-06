import 'package:flutter/material.dart';

import '../data/cooked_recipe_photo_data.dart';

class CookedPhotoGalleryScreen extends StatefulWidget {
  const CookedPhotoGalleryScreen({super.key});

  @override
  State<CookedPhotoGalleryScreen> createState() =>
      _CookedPhotoGalleryScreenState();
}

class _CookedPhotoGalleryScreenState extends State<CookedPhotoGalleryScreen> {
  String _selected = 'all';

  List<_GalleryPhotoItem> get _allPhotos {
    final items = <_GalleryPhotoItem>[];
    for (final recipe in cookedRecipePhotoData) {
      for (final photo in recipe.photos) {
        items.add(
          _GalleryPhotoItem(
            recipeId: recipe.id,
            recipeName: recipe.title,
            url: photo,
          ),
        );
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final allPhotos = _allPhotos;
    final filtered = _selected == 'all'
        ? allPhotos
        : allPhotos.where((photo) => photo.recipeId == _selected).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF6FC8B1),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Photo Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _CountInfo(
                          value: '${allPhotos.length}',
                          label: 'Total Photos',
                        ),
                        const Spacer(),
                        _CountInfo(
                          value: '${cookedRecipePhotoData.length}',
                          label: 'Recipes',
                          alignEnd: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Filter by recipe:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: _selected == 'all',
                          onTap: () => setState(() => _selected = 'all'),
                        ),
                        const SizedBox(width: 8),
                        for (final recipe in cookedRecipePhotoData) ...[
                          _FilterChip(
                            label: recipe.title,
                            selected: _selected == recipe.id,
                            onTap: () => setState(() => _selected = recipe.id),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final photo = filtered[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      photo.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE5EAF0),
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountInfo extends StatelessWidget {
  final String value;
  final String label;
  final bool alignEnd;

  const _CountInfo({
    required this.value,
    required this.label,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF2F8473) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _GalleryPhotoItem {
  final String recipeId;
  final String recipeName;
  final String url;

  const _GalleryPhotoItem({
    required this.recipeId,
    required this.recipeName,
    required this.url,
  });
}
