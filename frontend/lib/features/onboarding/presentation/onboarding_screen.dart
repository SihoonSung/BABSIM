import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  // Step 1: 닉네임
  final TextEditingController _nicknameController = TextEditingController();

  // Step 2: 알레르기
  final TextEditingController _allergyController = TextEditingController();
  final List<String> _allergies = [];

  // Step 3: 싫어하는 재료
  final TextEditingController _dislikedController = TextEditingController();
  final List<String> _disliked = [];

  // Step 4: 주방도구
  final List<String> _allTools = [
    'Air Fryer', 'Blender', 'Instant Pot', 'Rice Cooker',
    'Microwave', 'Oven', 'Toaster', 'Food Processor',
    'Stand Mixer', 'Wok', 'Cast Iron Pan', 'Dutch Oven',
  ];
  final Set<String> _selectedTools = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentNickname();
  }

  Future<void> _loadCurrentNickname() async {
    try {
      final response = await ApiClient.instance.dio.get('/auth/me');
      final data = response.data as Map<String, dynamic>;
      final nickname = data['nickname'] as String? ?? '';
      if (nickname.isNotEmpty) {
        _nicknameController.text = nickname;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _allergyController.dispose();
    _dislikedController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _isSaving = true);
    try {
      // 알레르기 저장
      await ApiClient.instance.dio.put(
        '/preferences/allergy',
        data: {'kind': 'allergy', 'values': _allergies},
      );
      // 싫어하는 재료 저장
      await ApiClient.instance.dio.put(
        '/preferences/disliked',
        data: {'kind': 'disliked', 'values': _disliked},
      );
      // 주방도구 저장
      await ApiClient.instance.dio.put(
        '/preferences/tool',
        data: {'kind': 'tool', 'values': _selectedTools.toList()},
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
    } catch (_) {
      // 저장 실패해도 홈으로 이동
    }
    if (mounted) context.go('/home');
  }

  bool get _canProceed {
    if (_currentPage == 0) return _nicknameController.text.trim().length >= 2;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 진행바
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentPage
                            ? AppTheme.primary
                            : const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // 건너뛰기 버튼
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isSaving ? null : _finish,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                ),
              ),
            ),
            // 페이지 본문
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _NicknameStep(controller: _nicknameController, onChanged: () => setState(() {})),
                  _TagInputStep(
                    title: 'Any allergies?',
                    subtitle: "We'll exclude recipes with these ingredients.",
                    emoji: '⚠️',
                    inputHint: 'e.g. Peanuts, Shellfish',
                    items: _allergies,
                    controller: _allergyController,
                    onAdd: (v) => setState(() => _allergies.add(v)),
                    onRemove: (v) => setState(() => _allergies.remove(v)),
                  ),
                  _TagInputStep(
                    title: 'Disliked ingredients?',
                    subtitle: "We'll down-rank recipes with these.",
                    emoji: '🚫',
                    inputHint: 'e.g. Eggplant, Cilantro',
                    items: _disliked,
                    controller: _dislikedController,
                    onAdd: (v) => setState(() => _disliked.add(v)),
                    onRemove: (v) => setState(() => _disliked.remove(v)),
                  ),
                  _ToolPickerStep(
                    allTools: _allTools,
                    selected: _selectedTools,
                    onToggle: (t) => setState(() {
                      if (!_selectedTools.remove(t)) _selectedTools.add(t);
                    }),
                  ),
                ],
              ),
            ),
            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_canProceed && !_isSaving) ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _currentPage < 3 ? 'Continue' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Step 1: 닉네임
class _NicknameStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _NicknameStep({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          const Text(
            'What should we\ncall you?',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'This name will appear on your profile.',
            style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 36),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            autofocus: true,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: 'Nickname',
              hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 2, 3: 태그 입력
class _TagInputStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final String inputHint;
  final List<String> items;
  final TextEditingController controller;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const _TagInputStep({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.inputHint,
    required this.items,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  void _submit() {
    final v = controller.text.trim();
    if (v.isNotEmpty) {
      onAdd(v);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 15, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: inputHint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppTheme.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'None added yet — you can skip this step.',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((item) {
                      return Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => onRemove(item),
                        backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        deleteIconColor: AppTheme.primary,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// Step 4: 주방도구 그리드 선택
class _ToolPickerStep extends StatelessWidget {
  final List<String> allTools;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _ToolPickerStep({
    required this.allTools,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🍳', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          const Text(
            'Your kitchen tools?',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "We'll suggest recipes that match your equipment.",
            style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: allTools.length,
              itemBuilder: (context, index) {
                final tool = allTools[index];
                final isSelected = selected.contains(tool);
                return GestureDetector(
                  onTap: () => onToggle(tool),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tool,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF555555),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
