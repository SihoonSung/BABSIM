class FridgeItem {
  final int id;
  final String nameKo;
  final String category;
  final String? quantity;

  const FridgeItem({
    required this.id,
    required this.nameKo,
    required this.category,
    this.quantity,
  });
}

const fridgeCategories = ['전체', '채소', '육류', '유제품', '양념', '곡물', '기타'];

// 카테고리별 아이콘 매핑
const categoryEmojis = {
  '채소': '🥦',
  '육류': '🥩',
  '유제품': '🧀',
  '양념': '🧂',
  '곡물': '🌾',
  '기타': '🫙',
};

// 임시 더미 데이터
final dummyFridgeItems = [
  const FridgeItem(id: 1, nameKo: '계란', category: '기타', quantity: '6개'),
  const FridgeItem(id: 2, nameKo: '당근', category: '채소', quantity: '2개'),
  const FridgeItem(id: 3, nameKo: '대파', category: '채소', quantity: '1단'),
  const FridgeItem(id: 4, nameKo: '돼지고기', category: '육류', quantity: '300g'),
  const FridgeItem(id: 5, nameKo: '두부', category: '기타', quantity: '1모'),
  const FridgeItem(id: 6, nameKo: '간장', category: '양념', quantity: '충분'),
  const FridgeItem(id: 7, nameKo: '고추장', category: '양념', quantity: '충분'),
  const FridgeItem(id: 8, nameKo: '우유', category: '유제품', quantity: '1L'),
  const FridgeItem(id: 9, nameKo: '양파', category: '채소', quantity: '3개'),
  const FridgeItem(id: 10, nameKo: '쌀', category: '곡물', quantity: '2kg'),
];
