import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';

class PreferenceEditorScreen extends StatefulWidget {
  final String title;
  final String description;
  final String kind; // 'allergy' | 'disliked' | 'tool'
  final IconData itemIcon;
  final String addButtonLabel;
  final String inputHint;

  const PreferenceEditorScreen({
    super.key,
    required this.title,
    required this.description,
    required this.kind,
    required this.itemIcon,
    required this.addButtonLabel,
    required this.inputHint,
  });

  @override
  State<PreferenceEditorScreen> createState() => _PreferenceEditorScreenState();
}

class _PreferenceEditorScreenState extends State<PreferenceEditorScreen> {
  static const _accentColor = Color(0xFFFC9946);
  static const _headerBackground = Color(0xFFFFEBD3);
  static const _surfaceBackground = Color(0xFFF4F6FA);
  static const _cardBorder = Color(0xFFE6EBF2);

  final List<String> _items = [];
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    try {
      final response = await ApiClient.instance.dio.get('/preferences/');
      final data = response.data as Map<String, dynamic>;
      final key = widget.kind == 'allergy'
          ? 'allergies'
          : widget.kind == 'disliked'
          ? 'disliked'
          : 'tools';
      final list = (data[key] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      if (mounted) setState(() { _items.addAll(list); _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await ApiClient.instance.dio.put(
        '/preferences/${widget.kind}',
        data: {'kind': widget.kind, 'values': _items},
      );
    } catch (_) {}
    if (mounted) setState(() => _isSaving = false);
  }

  void _startAdding() => setState(() => _isAdding = true);

  void _cancelAdding() {
    _controller.clear();
    setState(() => _isAdding = false);
  }

  void _submitAdd() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _items.add(value);
      _controller.clear();
      _isAdding = false;
    });
    _save();
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfaceBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: _headerBackground,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(18),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: _accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF182136),
                          ),
                        ),
                      ),
                      if (_isSaving)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _accentColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(left: 38),
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF4F5D74),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < _items.length; i++) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF2E4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          widget.itemIcon,
                                          size: 16,
                                          color: _accentColor,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _items[i],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1B2436),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _removeItem(i),
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: Color(0xFFFF4D4F),
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (i != _items.length - 1)
                                  const Divider(
                                    height: 1,
                                    indent: 56,
                                    endIndent: 14,
                                    color: Color(0xFFF0F3F7),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (!_isAdding)
                          OutlinedButton(
                            onPressed: _startAdding,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              side: const BorderSide(
                                color: Color(0xFFFFC8A2),
                                width: 1.2,
                              ),
                              foregroundColor: _accentColor,
                              backgroundColor: const Color(0xFFFFFCF8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  widget.addButtonLabel,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _cardBorder),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x12000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBFCFE),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _cardBorder),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      autofocus: true,
                                      onSubmitted: (_) => _submitAdd(),
                                      decoration: InputDecoration(
                                        hintText: widget.inputHint,
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF9AA7BA),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        isDense: true,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1B2436),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton(
                                  onPressed: _submitAdd,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(56, 40),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    backgroundColor: const Color(0xFFFFD4B2),
                                    foregroundColor: _accentColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: _cancelAdding,
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF6B778D),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
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
