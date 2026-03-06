import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF3F3F1),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopHeroSection(),
              SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: _SectionHeader(
                  title: 'Expiring Soon',
                  actionText: 'View All',
                  showAccentDot: true,
                ),
              ),
              SizedBox(height: 18),
              _ExpiringSoonList(),
              SizedBox(height: 36),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: _SectionHeader(title: 'For Your Dinner'),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: _FeaturedRecipeCard(),
              ),
              SizedBox(height: 72),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeroSection extends StatelessWidget {
  const _TopHeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE8C295),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 32),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_Header(), SizedBox(height: 30), _SavedRecipesCard()],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GOOD EVENING',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4E5563),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Alex User',
          style: TextStyle(
            fontSize: 31,
            height: 1,
            fontWeight: FontWeight.w800,
            color: Color(0xFF101B3B),
          ),
        ),
      ],
    );
  }
}

class _SavedRecipesCard extends StatelessWidget {
  const _SavedRecipesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2F1),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFECE9E8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EBE9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.bookmark_outline_rounded,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Saved Recipes',
                        style: TextStyle(
                          color: Color(0xFF18213D),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'See your collection',
                        style: TextStyle(
                          color: Color(0xFF7C889E),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF39554),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final bool showAccentDot;

  const _SectionHeader({
    required this.title,
    this.actionText,
    this.showAccentDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17213B),
              ),
            ),
            if (showAccentDot) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        if (actionText != null)
          Text(
            actionText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF18B45),
            ),
          ),
      ],
    );
  }
}

class _ExpiringSoonList extends StatelessWidget {
  const _ExpiringSoonList();

  @override
  Widget build(BuildContext context) {
    const items = [
      _ExpiringItem(
        name: 'Milk',
        daysLeftLabel: '1 day',
        fridgeLabel: 'FRIDGE A',
        illustration: _MilkIllustration(),
      ),
      _ExpiringItem(
        name: 'Spinach',
        daysLeftLabel: '2 days',
        fridgeLabel: 'FRIDGE A',
        illustration: _SpinachIllustration(),
      ),
      _ExpiringItem(
        name: 'Eggs',
        daysLeftLabel: '3 days',
        fridgeLabel: 'FRIDGE A',
        illustration: _EggIllustration(),
      ),
      _ExpiringItem(
        name: 'Butter',
        daysLeftLabel: '4 days',
        fridgeLabel: 'FRIDGE B',
        illustration: _ButterIllustration(),
      ),
    ];

    return SizedBox(
      height: 155,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final String name;
  final String daysLeftLabel;
  final String fridgeLabel;
  final Widget illustration;

  const _ExpiringItem({
    required this.name,
    required this.daysLeftLabel,
    required this.fridgeLabel,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF09A58),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                daysLeftLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 44,
            child: Align(alignment: Alignment.centerLeft, child: illustration),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF18203A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fridgeLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Color(0xFFA3AEC2),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedRecipeCard extends StatelessWidget {
  const _FeaturedRecipeCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Image.asset(
              'assets/images/creamy_garlic_pasta.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0.0, -0.08),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2B2A31),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.18),
                  Colors.black.withOpacity(0.28),
                  Colors.black.withOpacity(0.78),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF8EE5C5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: Color(0xFFFFD65C)),
                  SizedBox(width: 6),
                  Text(
                    '95% Match',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 230),
                  child: const Text(
                    'Creamy Garlic Pasta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 235),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 15,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Uses: Milk, Garlic, Butter',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => context.push('/recipes/1'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFF39855),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Start Cooking',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF58473B).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFF39A57),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilkIllustration extends StatelessWidget {
  const _MilkIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 3,
            child: Container(
              width: 18,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE2E2DE)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 22,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF7F7F5), Color(0xFFE3E2DD)],
                ),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD2D2CE)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinachIllustration extends StatelessWidget {
  const _SpinachIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 42,
      child: CustomPaint(painter: _SpinachPainter()),
    );
  }
}

class _EggIllustration extends StatelessWidget {
  const _EggIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _ButterIllustration extends StatelessWidget {
  const _ButterIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD96F),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 36,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFF3C853),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinachPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()..color = const Color(0xFF4F9A39);
    final stemPaint = Paint()
      ..color = const Color(0xFF2F6A1E)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final leftLeaf = Path()
      ..moveTo(size.width * 0.45, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.70,
        size.width * 0.14,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.10,
        size.width * 0.46,
        size.height * 0.12,
      )
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.58,
        size.width * 0.45,
        size.height * 0.92,
      );

    final rightLeaf = Path()
      ..moveTo(size.width * 0.46, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.70,
        size.width * 0.84,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.10,
        size.width * 0.48,
        size.height * 0.14,
      )
      ..quadraticBezierTo(
        size.width * 0.44,
        size.height * 0.56,
        size.width * 0.46,
        size.height * 0.92,
      );

    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.18),
      Offset(size.width * 0.46, size.height * 0.95),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
