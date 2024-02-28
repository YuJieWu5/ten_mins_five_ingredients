import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/ingredient_state.dart';

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({super.key});

  @override
  State<IngredientListPage> createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {

  @override
  Widget build(BuildContext context) {
    var ingredientList = context.watch<IngredientState>().ingredientList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ingredientList.length,
              itemBuilder: (context, index) {
                final ingredient = ingredientList[index];
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
                GoRouter.of(context).push('/recipeList');
              },
              child: const Text('Show me the recipes!'),
            ),
          ),
        ],
      ),
    );
  }
}
