import 'package:flutter/material.dart';

class DislikedIngredientsScreen extends StatefulWidget {
  const DislikedIngredientsScreen({super.key});

  @override
  State<DislikedIngredientsScreen> createState() =>
      _DislikedIngredientsScreenState();
}

class _DislikedIngredientsScreenState extends State<DislikedIngredientsScreen> {
  final List<String> _items = ['Eggplant', 'Cucumber'];

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Disliked Ingredient'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. Cilantro'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _items.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(title: const Text('Disliked Ingredients')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3F3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Add ingredients you dislike. We'll down-rank recipes that include these items.",
              style: TextStyle(color: Color(0xFF8D4752), fontSize: 14),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE7ECF3)),
            ),
            child: Column(
              children: [
                for (var i = 0; i < _items.length; i++) ...[
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.not_interested_rounded,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                    title: Text(
                      _items[i],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2738),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFFF3B30)),
                      onPressed: () => setState(() => _items.removeAt(i)),
                    ),
                  ),
                  if (i != _items.length - 1)
                    const Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Color(0xFFEFF2F6),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _showAddDialog,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              side: const BorderSide(color: Color(0xFFFF7E7E), width: 1.5),
              foregroundColor: const Color(0xFFE65757),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Add Ingredient',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
