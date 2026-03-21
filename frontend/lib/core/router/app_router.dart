import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/loading_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/fridge/presentation/fridge_screen.dart';
import '../../features/recipes/presentation/recipe_list_screen.dart';
import '../../features/recipes/presentation/recipe_detail_screen.dart';
import '../../features/recipes/presentation/saved_recipes_screen.dart'
    as recipes_saved;
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/allergies_screen.dart';
import '../../features/profile/presentation/disliked_ingredients_screen.dart';
import '../../features/profile/presentation/kitchen_tools_screen.dart';
import '../../features/profile/presentation/cooked_recipes_screen.dart';
import '../../features/profile/presentation/cooked_photo_gallery_screen.dart';
import '../../features/profile/presentation/cooked_recipe_photos_screen.dart';
import '../../features/profile/presentation/my_fridges_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../shell/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/loading'),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/saved-recipies',
      redirect: (context, state) => '/saved-recipes',
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/fridge',
          builder: (context, state) => const FridgeScreen(),
        ),
        GoRoute(
          path: '/recipes',
          builder: (context, state) => const RecipeListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => RecipeDetailScreen(
                recipeId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/saved-recipes',
          builder: (context, state) => const recipes_saved.SavedRecipesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
              path: 'allergies',
              builder: (context, state) => const AllergiesScreen(),
            ),
            GoRoute(
              path: 'disliked',
              builder: (context, state) => const DislikedIngredientsScreen(),
            ),
            GoRoute(
              path: 'tools',
              builder: (context, state) => const KitchenToolsScreen(),
            ),
            GoRoute(
              path: 'cooked',
              builder: (context, state) => const CookedRecipesScreen(),
              routes: [
                GoRoute(
                  path: 'gallery',
                  builder: (context, state) => const CookedPhotoGalleryScreen(),
                ),
                GoRoute(
                  path: 'photos/:recipeId',
                  builder: (context, state) => CookedRecipePhotosScreen(
                    recipeId: state.pathParameters['recipeId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'fridges',
              builder: (context, state) => const MyFridgesScreen(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
