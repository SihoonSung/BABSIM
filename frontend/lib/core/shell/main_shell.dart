import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  static const _tabRoutes = <String>[
    '/home',
    '/fridge',
    '/recipes',
    '/saved-recipes',
    '/profile',
  ];

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/fridge')) return 1;
    if (location.startsWith('/recipes')) return 2;
    if (location.startsWith('/saved-recipes')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  bool _showBottomNav(String location) => _tabRoutes.contains(location);

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: _showBottomNav(location)
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFD3D3D3))),
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        index: 0,
                        currentIndex: currentIndex,
                        onTap: () => context.go('/home'),
                      ),
                      _NavItem(
                        icon: Icons.kitchen_outlined,
                        selectedIcon: Icons.kitchen,
                        index: 1,
                        currentIndex: currentIndex,
                        onTap: () => context.go('/fridge'),
                      ),
                      _NavItem(
                        icon: Icons.menu_book_outlined,
                        selectedIcon: Icons.menu_book,
                        index: 2,
                        currentIndex: currentIndex,
                        onTap: () => context.go('/recipes'),
                      ),
                      _NavItem(
                        icon: Icons.bookmark_border_rounded,
                        selectedIcon: Icons.bookmark_rounded,
                        index: 3,
                        currentIndex: currentIndex,
                        onTap: () => context.go('/saved-recipes'),
                      ),
                      _NavItem(
                        icon: Icons.person_outline,
                        selectedIcon: Icons.person,
                        index: 4,
                        currentIndex: currentIndex,
                        onTap: () => context.go('/profile'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
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
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              )
            else
              const SizedBox(height: 11),
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppTheme.primary : const Color(0xFF90A0BB),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
