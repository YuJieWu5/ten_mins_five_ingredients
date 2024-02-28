import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ingredients.dart';

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({required this.ingredients, super.key});
  final List<Ingredient> ingredients;

  @override
  State<IngredientListPage> createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = widget.ingredients[index];
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
