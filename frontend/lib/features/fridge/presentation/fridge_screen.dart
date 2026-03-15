import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../data/fridge_item.dart';
import '../../../core/theme/app_theme.dart';
import 'add_ingredient_sheet.dart';
import 'ingredient_detail_screen.dart';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  static const _sampleUserId = '11111111-1111-1111-1111-111111111111';

  final Dio _dio = ApiClient.instance.dio;
  int _fridgeTab = 0;
  String _selectedCategory = 'All';
  List<_FridgeTabData> _fridges = [
    _FridgeTabData(
      id: 1,
      name: 'Main Fridge',
      items: List.from(dummyMainFridgeItems),
    ),
    _FridgeTabData(
      id: 2,
      name: 'Kimchi Fridge',
      items: List.from(dummyKimchiFridgeItems),
    ),
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<FridgeItem> get _currentItems {
    if (_fridges.isEmpty) return const [];
    final index = _fridgeTab.clamp(0, _fridges.length - 1);
    return _fridges[index].items;
  }

  List<FridgeItem> get _filtered {
    var items = _currentItems;
    if (_selectedCategory != 'All') {
      items = items.where((e) => e.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items.where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return items;
  }

  int? get _currentFridgeId {
    if (_fridges.isEmpty) return null;
    return _fridges[_fridgeTab.clamp(0, _fridges.length - 1)].id;
  }

  @override
  void initState() {
    super.initState();
    _loadFridge();
  }

  Future<void> _loadFridge() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _dio.get<Map<String, dynamic>>('/app/bootstrap/$_sampleUserId');
      final data = response.data ?? <String, dynamic>{};
      final fridgesJson = (data['fridges'] as List<dynamic>? ?? const []);
      final itemsJson = (data['fridge_items'] as List<dynamic>? ?? const []);
      final items = itemsJson
          .map((item) => FridgeItem.fromJson(item as Map<String, dynamic>))
          .toList();
      final fridges = fridgesJson.map((fridge) {
        final json = fridge as Map<String, dynamic>;
        final fridgeId = json['id'] as int;
        return _FridgeTabData(
          id: fridgeId,
          name: json['name'] as String,
          items: items.where((item) => item.fridgeId == fridgeId).toList(),
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _fridges = fridges.isEmpty ? _fridges : fridges.take(2).toList();
        if (_fridgeTab >= _fridges.length) {
          _fridgeTab = 0;
        }
        _isLoading = false;
      });
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message ?? 'Failed to load fridge';
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load fridge';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeItem(int id) async {
    final fridgeId = _currentFridgeId;
    if (fridgeId == null) return;
    setState(() {
      _fridges = _fridges.map((fridge) {
        if (fridge.id != fridgeId) return fridge;
        return fridge.copyWith(
          items: fridge.items.where((item) => item.id != id).toList(),
        );
      }).toList();
    });
    try {
      await _dio.delete<void>('/fridge/$_sampleUserId/$id');
    } on DioException {
      if (!mounted) return;
      _loadFridge();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete ingredient')),
      );
    }
  }

  Future<void> _updateItem(FridgeItem updated) async {
    final fridgeId = _currentFridgeId;
    if (fridgeId == null) return;
    final previous = _fridges;
    setState(() {
      _fridges = _fridges.map((fridge) {
        if (fridge.id != fridgeId) return fridge;
        final index = fridge.items.indexWhere((item) => item.id == updated.id);
        if (index == -1) return fridge;
        final items = List<FridgeItem>.from(fridge.items);
        items[index] = updated;
        return fridge.copyWith(items: items);
      }).toList();
    });

    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/fridge/$_sampleUserId/${updated.id}',
        data: updated.toUpdateJson(),
      );
      final saved = FridgeItem.fromJson(response.data ?? <String, dynamic>{});
      if (!mounted) return;
      setState(() {
        _fridges = _fridges.map((fridge) {
          if (fridge.id != fridgeId) return fridge;
          final index = fridge.items.indexWhere((item) => item.id == saved.id);
          if (index == -1) return fridge;
          final items = List<FridgeItem>.from(fridge.items);
          items[index] = saved;
          return fridge.copyWith(items: items);
        }).toList();
      });
    } on DioException {
      if (!mounted) return;
      setState(() => _fridges = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update ingredient')),
      );
    }
  }

  void _openDetail(FridgeItem item) {
    if (_isEditing) {
      setState(() => _isEditing = false);
      return;
    }
    showIngredientDetail(context, item, _updateItem);
  }

  void _enterEditMode() {
    HapticFeedback.mediumImpact();
    setState(() => _isEditing = true);
  }

  void _exitEditMode() {
    setState(() => _isEditing = false);
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddIngredientSheet(
        onAdd: _addItem,
      ),
    );
  }

  Future<void> _addItem(String name, String category, String quantity) async {
    final fridgeId = _currentFridgeId;
    if (fridgeId == null) return;
    try {
      await _dio.post<Map<String, dynamic>>(
        '/fridge/$_sampleUserId/manual',
        data: {
          'name': name,
          'category': category,
          'quantity': quantity.isEmpty ? null : quantity,
          'fridge_id': fridgeId,
        },
      );
      await _loadFridge();
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.statusCode == 409
          ? 'Ingredient already exists in this fridge'
          : 'Failed to add ingredient';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Fridge',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
        ),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _exitEditMode,
              child: const Text('Done', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
            )
          else
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1A1A)),
              onPressed: _enterEditMode,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Fridge / Kimchi Fridge 탭
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _FridgeTabSwitch(
              labels: _fridges.map((fridge) => fridge.name).take(2).toList(),
              selected: _fridgeTab,
              onSelect: (i) => setState(() {
                _fridgeTab = i;
                _selectedCategory = 'All';
              }),
            ),
          ),
          // 검색바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search ingredients...',
                hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFAAAAAA)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // 카테고리 탭
          _CategoryTabs(
            selected: _selectedCategory,
            onSelect: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 8),
          // 재료 그리드
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
    }
    if (_errorMessage != null) {
      return _ErrorState(
        message: _errorMessage!,
        onRetry: _loadFridge,
      );
    }
    if (_filtered.isEmpty) {
      return const _EmptyState();
    }
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _loadFridge,
      child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                        final item = _filtered[index];
                        return _IngredientCard(
                          item: item,
                          isEditing: _isEditing,
                          onRemove: () => _removeItem(item.id),
                          onTap: () => _openDetail(item),
                          onLongPress: _enterEditMode,
                        );
                      },
                  ),
    );
  }
}

class _FridgeTabSwitch extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;

  const _FridgeTabSwitch({
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabels = labels.length >= 2
        ? labels
        : const ['Main Fridge', 'Kimchi Fridge'];
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Tab(label: effectiveLabels[0], isSelected: selected == 0, onTap: () => onSelect(0)),
          _Tab(label: effectiveLabels[1], isSelected: selected == 1, onTap: () => onSelect(1)),
        ],
      ),
    );
  }
}

class _FridgeTabData {
  final int id;
  final String name;
  final List<FridgeItem> items;

  const _FridgeTabData({
    required this.id,
    required this.name,
    required this.items,
  });

  _FridgeTabData copyWith({
    int? id,
    String? name,
    List<FridgeItem>? items,
  }) {
    return _FridgeTabData(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF888888),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryTabs({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: fridgeCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final cat = fridgeCategories[index];
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : const Color(0xFF888888),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IngredientCard extends StatefulWidget {
  final FridgeItem item;
  final bool isEditing;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _IngredientCard({
    required this.item,
    required this.isEditing,
    required this.onRemove,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<_IngredientCard> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(_IngredientCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditing && !oldWidget.isEditing) {
      _shakeController.repeat(reverse: true);
    } else if (!widget.isEditing) {
      _shakeController.stop();
      _shakeController.reset();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Color _expiryColor(int days) {
    if (days <= 1) return const Color(0xFFFF3B30);
    if (days <= 3) return const Color(0xFFFF9500);
    return const Color(0xFF34C759);
  }

  double _expiryProgress(int days) {
    if (days <= 1) return 0.2;
    if (days <= 3) return 0.5;
    return 0.85;
  }

  @override
  Widget build(BuildContext context) {
    final emoji = categoryEmojis[widget.item.category] ?? '🫙';
    final days = widget.item.daysUntilExpiry;

    Widget card = GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (days != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _expiryColor(days).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Exp ${days}d',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _expiryColor(days),
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 48)),
                ),
              ),
              Text(
                widget.item.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (widget.item.quantity != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.item.quantity!,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
              ],
              if (days != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _expiryProgress(days),
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation(_expiryColor(days)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.isEditing ? _shakeAnimation.value : 0,
          child: Stack(
            children: [
              child!,
              if (widget.isEditing)
                Positioned(
                  top: 4,
                  left: 4,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white, size: 14),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      child: card,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🧺', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'No ingredients',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
          ),
          SizedBox(height: 4),
          Text(
            'Tap + to add ingredients',
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 42)),
            const SizedBox(height: 12),
            const Text(
              'Could not load fridge',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
