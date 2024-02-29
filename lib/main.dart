import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe_state.dart';
import 'core/models/global_state.dart';
import 'core/models/ingredient_state.dart';
import 'core/services/firebase_initializer.dart';
import 'routes/app_routes.dart';

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
        ChangeNotifierProvider(create: (context) => IngredientState()),
        ChangeNotifierProvider(create: (context) => RecipeState()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}