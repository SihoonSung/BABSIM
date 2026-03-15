enum StorageType { refrigerated, roomTemp, frozen }

class FridgeItem {
  final int id;
  final int? fridgeId;
  final String? fridgeName;
  final String name;
  final String category;
  final String? quantity;
  final int? daysUntilExpiry;
  final StorageType storageType;
  final bool expiryReminder;

  const FridgeItem({
    required this.id,
    this.fridgeId,
    this.fridgeName,
    required this.name,
    required this.category,
    this.quantity,
    this.daysUntilExpiry,
    this.storageType = StorageType.refrigerated,
    this.expiryReminder = true,
  });

  FridgeItem copyWith({
    int? fridgeId,
    String? fridgeName,
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
      fridgeId: fridgeId ?? this.fridgeId,
      fridgeName: fridgeName ?? this.fridgeName,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      daysUntilExpiry: clearExpiry ? null : (daysUntilExpiry ?? this.daysUntilExpiry),
      storageType: storageType ?? this.storageType,
      expiryReminder: expiryReminder ?? this.expiryReminder,
    );
  }

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
      id: json['id'] as int,
      fridgeId: json['fridge_id'] as int?,
      fridgeName: json['fridge_name'] as String?,
      name: (json['name'] ?? json['ingredient_name_ko']) as String,
      category: (json['category'] ?? json['ingredient_category']) as String,
      quantity: json['quantity'] as String?,
      daysUntilExpiry: json['days_until_expiry'] as int?,
      storageType: storageTypeFromApi(json['storage_type'] as String?),
      expiryReminder: json['expiry_reminder'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'quantity': quantity,
      'storage_type': storageTypeToApi(storageType),
      'days_until_expiry': daysUntilExpiry,
      'expiry_reminder': expiryReminder,
    };
  }
}

StorageType storageTypeFromApi(String? value) {
  switch (value) {
    case 'room_temp':
      return StorageType.roomTemp;
    case 'frozen':
      return StorageType.frozen;
    case 'refrigerated':
    default:
      return StorageType.refrigerated;
  }
}

String storageTypeToApi(StorageType value) {
  switch (value) {
    case StorageType.roomTemp:
      return 'room_temp';
    case StorageType.frozen:
      return 'frozen';
    case StorageType.refrigerated:
      return 'refrigerated';
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
