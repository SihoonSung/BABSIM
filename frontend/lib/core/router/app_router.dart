import 'package:go_router/go_router.dart';

import '../../features/fridge/presentation/fridge_screen.dart';
import '../../features/recipes/presentation/recipe_list_screen.dart';
import '../../features/recipes/presentation/recipe_detail_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../shell/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/fridge',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
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
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
