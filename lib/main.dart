import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe_state.dart';
import 'package:ten_mins_five_ingredients/core/services/firebase_options.dart';
import 'core/models/global_state.dart';
import 'core/models/ingredient_state.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(storage: FirebaseStorage.instance, database: FirebaseDatabase.instance, auth: FirebaseAuth.instance));
}

class MyApp extends StatelessWidget {
  final FirebaseStorage storage;
  final FirebaseDatabase database;
  final FirebaseAuth auth;
  const MyApp({required this.storage, required this.database, required this.auth, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalState(false, storage, database, auth)),
        ChangeNotifierProvider(create: (context) => IngredientState()),
        ChangeNotifierProvider(create: (context) => RecipeState()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}