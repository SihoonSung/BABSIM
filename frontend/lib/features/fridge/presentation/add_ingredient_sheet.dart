import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AddIngredientSheet extends StatelessWidget {
  final FutureOr<void> Function(String name, String category, String quantity) onAdd;

  const AddIngredientSheet({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 32 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Ingredients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Color(0xFF888888), size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _OptionCard(
            icon: Icons.receipt_long_outlined,
            iconColor: const Color(0xFF3D5AFE),
            iconBg: const Color(0xFFECEEFD),
            title: 'Scan Receipt',
            subtitle: 'Automatically extract ingredients from receipt',
            onTap: () {
              Navigator.pop(context);
              // TODO: 영수증 스캔
            },
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.camera_alt_outlined,
            iconColor: const Color(0xFF9C27B0),
            iconBg: const Color(0xFFF3E5F5),
            title: 'Add Ingredient Photo',
            subtitle: 'Take or upload photos of ingredients',
            onTap: () {
              Navigator.pop(context);
              // TODO: 사진으로 추가
            },
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.edit_outlined,
            iconColor: const Color(0xFF34C759),
            iconBg: const Color(0xFFEAF8EE),
            title: 'Enter Manually',
            subtitle: 'Type in ingredient name and quantity',
            onTap: () {
              Navigator.pop(context);
              _openManualSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _openManualSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ManualAddSheet(onAdd: onAdd),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualAddSheet extends StatefulWidget {
  final FutureOr<void> Function(String name, String category, String quantity) onAdd;

  const _ManualAddSheet({required this.onAdd});

  @override
  State<_ManualAddSheet> createState() => _ManualAddSheetState();
}

class _ManualAddSheetState extends State<_ManualAddSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategory = 'Vegetables';

  final _categories = ['Vegetables', 'Meat', 'Dairy', 'Grains', 'Sauce', 'Other'];
  final _categoryEmojis = {
    'Vegetables': '🥦',
    'Meat': '🥩',
    'Dairy': '🧀',
    'Sauce': '🧂',
    'Grains': '🌾',
    'Other': '🫙',
  };

  bool get _canSubmit => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) return;
    widget.onAdd(
      _nameController.text.trim(),
      _selectedCategory,
      _quantityController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Enter Manually', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Eggs, Tofu, Carrots'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity (optional)', hintText: 'e.g. 2 pcs, 300g'),
          ),
          const SizedBox(height: 16),
          const Text('Category', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = cat == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_categoryEmojis[cat] ?? ''} $cat',
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canSubmit ? _submit : null,
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
