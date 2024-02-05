import 'package:flutter/material.dart';
import 'ingredients.dart';
import 'recipe_list_page.dart';

class IngredientListPage extends StatefulWidget {
  @override
  _IngredientListPageState createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {
  // Example list of ingredients
  final List<Ingredient> ingredients = [
    Ingredient(name: 'Tomatoes', emoji: '🍅'),
    Ingredient(name: 'Cheese', emoji: '🧀'),
    Ingredient(name: 'Bread', emoji: '🍞'),
    // TODO: Image Recognition API
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredient List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return CheckboxListTile(
                  title: Text('${ingredient.emoji} ${ingredient.name}'),
                  value: ingredient.isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      ingredient.isSelected = value!;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeList()),
                );
              },
              child: Text('Show me the recipes!'),
            ),
          ),
        ],
      ),
    );
  }
}
