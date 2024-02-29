import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe_state.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe.dart';
import 'package:ten_mins_five_ingredients/core/widgets/loading.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Ingredient/get_recipe_list.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Ingredient/ingredients_list.dart';
import 'package:ten_mins_five_ingredients/views/User/log_in.dart';
import 'package:ten_mins_five_ingredients/views/User/sign_up.dart';
import 'package:ten_mins_five_ingredients/views/Home/homepage.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/recipe_list_page.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Upload/photo_capture_page.dart';
import 'package:ten_mins_five_ingredients/views/Home/recipe_detail.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/Upload/upload_recipe_page.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/save_list.dart';
import 'package:ten_mins_five_ingredients/views/Recipe/RecipeList/create_list.dart';

final GoRouter router = GoRouter(
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
            final Recipe recipe = state.extra as Recipe;
            return RecipeDetail(recipe: recipe);
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
          path: 'ingredientList',
          builder: (BuildContext context, GoRouterState state) {
            return const IngredientListPage();
          },
        ),
        GoRoute(
          path: 'saveList',
          builder: (BuildContext context, GoRouterState state) {
            return const SaveList();
          },
        ),
        GoRoute(
          path: 'createList',
          builder: (BuildContext context, GoRouterState state) {
            return const CreateList();
          },
        ),
        GoRoute(
          path: 'loading',
          builder: (BuildContext context, GoRouterState state) {
            return LoadingWidget();
          },
        ),
        GoRoute(
          path: 'getRecipeList',
          builder: (BuildContext context, GoRouterState state) {
            return GetRecipeList();
          },
        ),
      ],
    ),
  ],
);