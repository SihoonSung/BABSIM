enum StorageType { refrigerated, roomTemp, frozen }

class FridgeItem {
  final int id;
  final String name;
  final String category;
  final String? quantity;
  final int? daysUntilExpiry;
  final StorageType storageType;
  final bool expiryReminder;

  const FridgeItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity,
    this.daysUntilExpiry,
    this.storageType = StorageType.refrigerated,
    this.expiryReminder = true,
  });

  FridgeItem copyWith({
    String? name,
    String? category,
    String? quantity,
    int? daysUntilExpiry,
    bool clearExpiry = false,
    StorageType? storageType,
    bool? expiryReminder,
  }) {
    return FridgeItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      daysUntilExpiry: clearExpiry ? null : (daysUntilExpiry ?? this.daysUntilExpiry),
      storageType: storageType ?? this.storageType,
      expiryReminder: expiryReminder ?? this.expiryReminder,
    );
  }
}

const fridgeCategories = ['All', 'Vegetables', 'Meat', 'Dairy', 'Grains', 'Sauce', 'Other'];

const categoryEmojis = {
  'Vegetables': '🥦',
  'Meat': '🥩',
  'Dairy': '🧀',
  'Sauce': '🧂',
  'Grains': '🌾',
  'Other': '🫙',
};

final dummyMainFridgeItems = [
  const FridgeItem(id: 1, name: 'Milk', category: 'Dairy', quantity: '1L', daysUntilExpiry: 1),
  const FridgeItem(id: 2, name: 'Eggs', category: 'Other', quantity: '6 pcs', daysUntilExpiry: 3),
  const FridgeItem(id: 3, name: 'Carrots', category: 'Vegetables', quantity: '3 pcs', daysUntilExpiry: 5),
  const FridgeItem(id: 4, name: 'Beef', category: 'Meat', quantity: '500g', daysUntilExpiry: 2),
  const FridgeItem(id: 5, name: 'Tofu', category: 'Other', quantity: '1 block', daysUntilExpiry: 4),
  const FridgeItem(id: 6, name: 'Soy Sauce', category: 'Sauce', quantity: 'enough'),
];

final dummyKimchiFridgeItems = [
  const FridgeItem(id: 101, name: 'Kimchi', category: 'Other', quantity: '2kg', daysUntilExpiry: 30),
  const FridgeItem(id: 102, name: 'Radish Kimchi', category: 'Vegetables', quantity: '1kg', daysUntilExpiry: 20),
];
