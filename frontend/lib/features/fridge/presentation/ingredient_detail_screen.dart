import 'dart:async';

import 'package:flutter/material.dart';

import '../data/fridge_item.dart';
import '../../../core/theme/app_theme.dart';

void showIngredientDetail(
  BuildContext context,
  FridgeItem item,
  FutureOr<void> Function(FridgeItem) onSave,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => IngredientDetailSheet(item: item, onSave: onSave),
  );
}

class IngredientDetailSheet extends StatefulWidget {
  final FridgeItem item;
  final FutureOr<void> Function(FridgeItem updated) onSave;

  const IngredientDetailSheet({super.key, required this.item, required this.onSave});

  @override
  State<IngredientDetailSheet> createState() => _IngredientDetailSheetState();
}

class _IngredientDetailSheetState extends State<IngredientDetailSheet> {
  late StorageType _storageType;
  late int _quantity;
  late bool _reminder;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    _storageType = widget.item.storageType;
    _quantity = int.tryParse(widget.item.quantity?.replaceAll(RegExp(r'[^0-9]'), '') ?? '1') ?? 1;
    _reminder = widget.item.expiryReminder;
    if (widget.item.daysUntilExpiry != null) {
      _expiryDate = DateTime.now().add(Duration(days: widget.item.daysUntilExpiry!));
    }
  }

  void _save() {
    final updated = widget.item.copyWith(
      storageType: _storageType,
      quantity: _quantity.toString(),
      expiryReminder: _reminder,
      daysUntilExpiry: _expiryDate != null
          ? _expiryDate!.difference(DateTime.now()).inDays
          : null,
      clearExpiry: _expiryDate == null,
    );
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final emoji = categoryEmojis[widget.item.category] ?? '🫙';
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          // 앱바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 28, color: Color(0xFF1A1A1A)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Ingredient Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          // 스크롤 내용
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 + 이름
                  Center(
                    child: Column(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 80)),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.category,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Storage Type
                  const Text('Storage Type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StorageCard(
                        emoji: '❄️',
                        label: 'Refrigerated',
                        isSelected: _storageType == StorageType.refrigerated,
                        onTap: () => setState(() => _storageType = StorageType.refrigerated),
                      ),
                      const SizedBox(width: 10),
                      _StorageCard(
                        emoji: '🌡️',
                        label: 'Room Temp',
                        isSelected: _storageType == StorageType.roomTemp,
                        onTap: () => setState(() => _storageType = StorageType.roomTemp),
                      ),
                      const SizedBox(width: 10),
                      _StorageCard(
                        emoji: '🧊',
                        label: 'Frozen',
                        isSelected: _storageType == StorageType.frozen,
                        onTap: () => setState(() => _storageType = StorageType.frozen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Quantity
                  const Text('Quantity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _RoundButton(
                        icon: Icons.remove,
                        onTap: () => setState(() { if (_quantity > 1) _quantity--; }),
                        filled: false,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                          ),
                        ),
                      ),
                      _RoundButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity++),
                        filled: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Expiration Date
                  const Text('Expiration Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(primary: AppTheme.primary),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) setState(() => _expiryDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF888888), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _expiryDate != null
                                ? '${_expiryDate!.year}/${_expiryDate!.month.toString().padLeft(2, '0')}/${_expiryDate!.day.toString().padLeft(2, '0')}'
                                : '',
                            style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Expiration Reminder
                  const Text('Expiration Reminder', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => setState(() => _reminder = !_reminder),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _reminder ? const Color(0xFFFFF3EC) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _reminder ? AppTheme.primary.withValues(alpha: 0.3) : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _reminder ? AppTheme.primary : const Color(0xFFDDDDDD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _reminder ? 'Reminder Active' : 'Reminder Off',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _reminder ? AppTheme.primary : const Color(0xFF888888),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _reminder ? 'You will be notified before expiration' : 'Tap to enable reminder',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StorageCard({required this.emoji, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF3EC) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primary : const Color(0xFFE0E0E0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : const Color(0xFF888888),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _RoundButton({required this.icon, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled ? AppTheme.primary : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: filled ? Colors.white : const Color(0xFF555555), size: 20),
      ),
    );
  }
}
