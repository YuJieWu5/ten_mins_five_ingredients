import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/services/firebase_options.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/save_list.dart';
import 'package:ten_mins_five_ingredients/views/User/log_in.dart';
import 'package:ten_mins_five_ingredients/views/User/sign_up.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/recipe_list_page.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Upload/photo_capture_page.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Upload/upload_recipe_page.dart';
import 'core/models/global_state.dart';
import 'core/services/firebase_initializer.dart';

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
        GoRoute(
          path: 'saveList',
          builder: (BuildContext context, GoRouterState state) {
            return const SaveList();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalState(false)),
        // ChangeNotifierProvider(create: (context) => AnotherModel()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}