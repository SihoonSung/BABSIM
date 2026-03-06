import 'package:flutter/material.dart';

class MyFridgesScreen extends StatelessWidget {
  const MyFridgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFE8F7F1),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF076B56),
                        ),
                      ),
                      const Text(
                        'My Fridges',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF076B56),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.add, color: Color(0xFF0D8A6E)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: _CountItem(value: '3', label: 'Total Fridges'),
                        ),
                        Expanded(
                          child: _CountItem(
                            value: '8',
                            label: 'Total Ingredients',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const _Label('MAIN FRIDGE'),
                  const SizedBox(height: 8),
                  _FridgeCard(
                    title: 'Main Fridge',
                    subtitle: '4 ingredients',
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFF79D5AE),
                  ),
                  const SizedBox(height: 14),
                  const _Label('SUB FRIDGES'),
                  const SizedBox(height: 8),
                  _FridgeCard(
                    title: 'Kimchi Fridge',
                    subtitle: '2 ingredients',
                    icon: Icons.inventory_2_outlined,
                    iconColor: const Color(0xFFFFA15D),
                    selected: true,
                  ),
                  const SizedBox(height: 10),
                  _FridgeCard(
                    title: 'Wine Cooler',
                    subtitle: '2 ingredients',
                    icon: Icons.hexagon_outlined,
                    iconColor: const Color(0xFFB398FF),
                  ),
                  const SizedBox(height: 14),
                  const _Label('INGREDIENTS IN KIMCHI FRIDGE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE7ECF3)),
                    ),
                    child: const Column(
                      children: [
                        _IngredientRow(
                          name: 'Cabbage Kimchi',
                          amount: '1kg',
                          expiry: '30d left',
                        ),
                        Divider(
                          height: 1,
                          indent: 14,
                          endIndent: 14,
                          color: Color(0xFFEFF2F6),
                        ),
                        _IngredientRow(
                          name: 'Radish Kimchi',
                          amount: '500g',
                          expiry: '25d left',
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

class _CountItem extends StatelessWidget {
  final String value;
  final String label;

  const _CountItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D2738),
          ),
        ),
        Text(label, style: const TextStyle(color: Color(0xFF6F819C))),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8EA0BD),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _FridgeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool selected;

  const _FridgeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? const Color(0xFF20C997) : const Color(0xFFE7ECF3),
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2738),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF8EA0BD)),
                ),
              ],
            ),
          ),
          const Icon(Icons.star_outline_rounded, color: Color(0xFFB7C3D8)),
          const SizedBox(width: 8),
          const Icon(Icons.edit_outlined, color: Color(0xFF9CB0C9), size: 20),
          const SizedBox(width: 8),
          const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFD0D9E6),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String name;
  final String amount;
  final String expiry;

  const _IngredientRow({
    required this.name,
    required this.amount,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF1D2738),
                  ),
                ),
                const SizedBox(height: 2),
                Text(amount, style: const TextStyle(color: Color(0xFF8EA0BD))),
              ],
            ),
          ),
          Text(
            expiry,
            style: const TextStyle(
              color: Color(0xFF8EA0BD),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
