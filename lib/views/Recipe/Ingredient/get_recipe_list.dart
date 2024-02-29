import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/recipe_state.dart';

class GetRecipeList extends StatelessWidget {
  const GetRecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    var recipeList = context.read<RecipeState>().recipeList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe List'),
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: (){
              GoRouter.of(context).pop();
            }
        ),
      ),
      body: ListView(
          children: recipeList.map((item)=>ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                'assets/images/tomatoes_and_burrata.jpg',
                fit: BoxFit.contain,
              ),
            ),
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: IconButton(
              key: Key(item.title),
              icon: const Icon(Icons.chevron_right),
              onPressed: ()=> GoRouter.of(context).push('/recipeDetail', extra: item),
            ),
            isThreeLine: true,
          )).toList()
      ),
    );
  }
}
