import 'package:flutter/material.dart';

class KitchenToolsScreen extends StatefulWidget {
  const KitchenToolsScreen({super.key});

  @override
  State<KitchenToolsScreen> createState() => _KitchenToolsScreenState();
}

class _KitchenToolsScreenState extends State<KitchenToolsScreen> {
  final List<String> _items = ['Air Fryer', 'Blender'];

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Kitchen Tool'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. Rice Cooker'),
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFEFF1FF),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF3A46A6),
                        ),
                      ),
                      const Text(
                        'Kitchen Tools',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3A46A6),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Text(
                      "Add kitchen tools you own. We'll suggest recipes you can make with your equipment.",
                      style: TextStyle(fontSize: 13, color: Color(0xFF3A46A6)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                children: [
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
                                color: const Color(0xFFEEF1FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.blender_outlined,
                                color: Color(0xFF5F6BFF),
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
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xFFFF3B30),
                              ),
                              onPressed: () =>
                                  setState(() => _items.removeAt(i)),
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
                      side: const BorderSide(
                        color: Color(0xFF8D9BFF),
                        width: 1.5,
                      ),
                      foregroundColor: const Color(0xFF4A56D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Kitchen Tool',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
