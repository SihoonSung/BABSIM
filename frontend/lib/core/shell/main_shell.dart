import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/fridge')) return 1;
    if (location.startsWith('/recipes')) return 2;
    if (location.startsWith('/profile')) return 4;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, index: 0, currentIndex: currentIndex, onTap: () {}),
                _NavItem(icon: Icons.kitchen_outlined, selectedIcon: Icons.kitchen, index: 1, currentIndex: currentIndex, onTap: () => context.go('/fridge')),
                _NavItem(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, index: 2, currentIndex: currentIndex, onTap: () => context.go('/recipes')),
                _NavItem(icon: Icons.group_outlined, selectedIcon: Icons.group, index: 3, currentIndex: currentIndex, onTap: () {}),
                _NavItem(icon: Icons.person_outline, selectedIcon: Icons.person, index: 4, currentIndex: currentIndex, onTap: () => context.go('/profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppTheme.primary : const Color(0xFFAAAAAA),
              size: 24,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
