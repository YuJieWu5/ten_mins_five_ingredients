import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/firebase_options.dart';
import 'User/log_in.dart';
import 'User/sign_up.dart';
import 'Home/homepage.dart';
import 'Recipe/RecipeList/recipe_list_page.dart';
import 'Recipe/Upload/photo_capture_page.dart';
import 'Home/recipe_detail.dart';
import 'Recipe/Upload/upload_recipe_page.dart';
import './global_state.dart';
import 'firebase_initializer.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LogInPage();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LogInPage();
          },
        ),
        GoRoute(
          path: 'recipeList',
          builder: (BuildContext context, GoRouterState state) {
            return const RecipeList();
          },
        ),
        GoRoute(
          path: 'recipeDetail',
          builder: (BuildContext context, GoRouterState state) {
            return const RecipeDetail();
          },
        ),
        GoRoute(
          path: 'getRecipe',
          builder: (BuildContext context, GoRouterState state) {
            return const PhotoCapturePage();
          },
        ),
        GoRoute(
          path: 'uploadRecipe',
          builder: (BuildContext context, GoRouterState state) {
            return const UploadRecipePage();
          },
        ),
      ],
    ),
  ],
);

void main() {
  // runApp(const MyApp());
  runApp(const FirebaseInitializer());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GlobalState(false),
        child: MaterialApp.router(
          routerConfig: _router,
        ));
  }
}
