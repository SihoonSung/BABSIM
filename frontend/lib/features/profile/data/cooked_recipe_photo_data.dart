class CookedRecipePhotoData {
  final String id;
  final String title;
  final String category;
  final String time;
  final String servings;
  final String lastCooked;
  final String cookedCount;
  final int stars;
  final List<String> photos;

  const CookedRecipePhotoData({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.servings,
    required this.lastCooked,
    required this.cookedCount,
    required this.stars,
    required this.photos,
  });

  String get coverPhoto => photos.first;
}

const List<CookedRecipePhotoData> cookedRecipePhotoData = [
  CookedRecipePhotoData(
    id: 'kimchi-stew',
    title: 'Kimchi Stew',
    category: 'Korean',
    time: '30 min',
    servings: '2-3 servings',
    lastCooked: 'Last: Today',
    cookedCount: 'Cooked 12 times',
    stars: 5,
    photos: [
      'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&h=800&fit=crop',
    ],
  ),
  CookedRecipePhotoData(
    id: 'creamy-pasta',
    title: 'Creamy Pasta',
    category: 'Italian',
    time: '15 min',
    servings: '2 servings',
    lastCooked: 'Last: Yesterday',
    cookedCount: 'Cooked 8 times',
    stars: 4,
    photos: [
      'https://images.unsplash.com/photo-1608756687911-aa1599ab0386?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800&h=800&fit=crop',
    ],
  ),
  CookedRecipePhotoData(
    id: 'avocado-toast',
    title: 'Avocado Toast',
    category: 'Western',
    time: '10 min',
    servings: '1 serving',
    lastCooked: 'Last: 2 days ago',
    cookedCount: 'Cooked 25 times',
    stars: 5,
    photos: [
      'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1546554137-f86b9593a222?w=800&h=800&fit=crop',
    ],
  ),
  CookedRecipePhotoData(
    id: 'fresh-salad-bowl',
    title: 'Fresh Salad Bowl',
    category: 'Healthy',
    time: '10 min',
    servings: '1 serving',
    lastCooked: 'Last: 3 days ago',
    cookedCount: 'Cooked 15 times',
    stars: 4,
    photos: [
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800&h=800&fit=crop',
      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&h=800&fit=crop',
    ],
  ),
];

CookedRecipePhotoData? findCookedRecipeById(String id) {
  for (final recipe in cookedRecipePhotoData) {
    if (recipe.id == id) return recipe;
  }
  return null;
}
