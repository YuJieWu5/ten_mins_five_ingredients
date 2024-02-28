import 'package:flutter/foundation.dart';
import './ingredients.dart';

class IngredientState with ChangeNotifier {
  List<Ingredient> _ingredientList = [];

  List<Ingredient> get ingredientList => _ingredientList;

  set ingredientList(List<Ingredient> newIngredientList) {
    _ingredientList = newIngredientList;
    notifyListeners();
  }
}