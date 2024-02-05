import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './log_in.dart';
import './sign_up.dart';
import './homepage.dart';
import './recipe_list_page.dart';
import './photo_capture_page.dart';
import './recipe_detail.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LogInPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
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
            return PhotoCapturePage();
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
    //   MaterialApp(
    //   title: '10mins5ingredients',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: HomePage(),
    // );
  }
}