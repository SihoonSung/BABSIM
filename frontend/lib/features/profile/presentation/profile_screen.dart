import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(
                onEditProfile: () => context.push('/profile/edit'),
              ),
              const SizedBox(height: 20),
              const _SectionTitle('PREFERENCES'),
              _MenuCard(
                items: [
                  _MenuItemData(
                    title: 'Allergies',
                    subtitle: 'Peanuts, Shellfish',
                    icon: Icons.warning_amber_rounded,
                    iconBg: const Color(0xFFFFF4E8),
                    iconColor: const Color(0xFFFF9800),
                    onTap: () => context.push('/profile/allergies'),
                  ),
                  _MenuItemData(
                    title: 'Disliked Ingredients',
                    subtitle: 'Eggplant, Cucumber',
                    icon: Icons.not_interested_rounded,
                    iconBg: const Color(0xFFFFF1F1),
                    iconColor: const Color(0xFFFF3B30),
                    onTap: () => context.push('/profile/disliked'),
                  ),
                  _MenuItemData(
                    title: 'Kitchen Tools',
                    subtitle: 'Air Fryer, Blender',
                    icon: Icons.blender_outlined,
                    iconBg: const Color(0xFFEEF0FF),
                    iconColor: const Color(0xFF5F6BFF),
                    onTap: () => context.push('/profile/tools'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _SectionTitle('MANAGEMENT'),
              _MenuCard(
                items: [
                  _MenuItemData(
                    title: 'Saved Recipes',
                    subtitle: '12 recipes',
                    icon: Icons.bookmark_border_rounded,
                    iconBg: const Color(0xFFFFEDD8),
                    iconColor: const Color(0xFFF59E4B),
                    onTap: () => context.push('/profile/saved'),
                  ),
                  _MenuItemData(
                    title: 'Cooked Recipes',
                    subtitle: '16 recipes',
                    icon: Icons.soup_kitchen_outlined,
                    iconBg: const Color(0xFFE8F6F0),
                    iconColor: const Color(0xFF5BBE9A),
                    onTap: () => context.push('/profile/cooked'),
                  ),
                  _MenuItemData(
                    title: 'My Fridges',
                    subtitle: 'Main, Kimchi, Wine Cooler',
                    icon: Icons.kitchen_outlined,
                    iconBg: const Color(0xFFE9F8F1),
                    iconColor: const Color(0xFF27B07D),
                    onTap: () => context.push('/profile/fridges'),
                  ),
                  _MenuItemData(
                    title: 'Settings',
                    subtitle: '',
                    icon: Icons.settings_outlined,
                    iconBg: const Color(0xFFF2F4F8),
                    iconColor: const Color(0xFF6F7C93),
                    onTap: () => context.push('/profile/settings'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFF3B30),
                  ),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(62),
                    side: const BorderSide(color: Color(0xFFE1E4EA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final VoidCallback onEditProfile;

  const _ProfileHeader({required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 210,
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 18),
            decoration: const BoxDecoration(
              color: Color(0xFFF09154),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFFFFD8BE),
                      child: Icon(
                        Icons.person,
                        size: 38,
                        color: Color(0xFF8A4D26),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFD8BE),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 12,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        'Alex User',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Master Chef in Training',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: onEditProfile,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: const Size(138, 42),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  _StatItem(value: '12', label: 'SAVED'),
                  _Divider(),
                  _StatItem(value: '16', label: 'COOKED'),
                  _Divider(),
                  _StatItem(value: '3', label: 'FRIDGES'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222C3E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8EA0BD),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 36,
      child: VerticalDivider(color: Color(0xFFE9EDF3), width: 1),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8EA0BD),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _MenuItem(item: items[i]),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: Color(0xFFEFF2F6),
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
}

class _MenuItem extends StatelessWidget {
  final _MenuItemData item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2436),
                    ),
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8EA0BD),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFB7C3D8)),
          ],
        ),
      ),
    );
  }
}
